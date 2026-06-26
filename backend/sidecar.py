"""
SmartBursar IPC Sidecar

This Python process runs as a Tauri child and communicates with the frontend via JSON-RPC over stdin/stdout.

Protocol: JSON-RPC 2.0
Transport: stdin/stdout (line-delimited JSON)

Messages from React:
{
  "jsonrpc": "2.0",
  "id": <number>,
  "method": "<service>.<action>",
  "params": {...}
}

Responses to React:
{
  "jsonrpc": "2.0",
  "id": <number>,
  "result": {...}
}

or error:
{
  "jsonrpc": "2.0",
  "id": <number>,
  "error": {"code": <number>, "message": "<string>"}
}

Notifications (from Python to React, no id):
{
  "jsonrpc": "2.0",
  "method": "event.<type>",
  "params": {...}
}
"""

import json
import sys
import logging
from typing import Any, Dict, Optional

# Setup logging to stderr so it doesn't interfere with IPC
logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] %(levelname)s: %(message)s',
    stream=sys.stderr
)
logger = logging.getLogger(__name__)


class JSONRPCError(Exception):
    """JSON-RPC error response"""
    def __init__(self, code: int, message: str):
        self.code = code
        self.message = message


class IPCSidecar:
    """Handles JSON-RPC messages over stdin/stdout"""

    def __init__(self):
        self.request_id: Optional[int] = None
        self.methods = {
            'ping.echo': self.echo,
            'status.check': self.status_check,
        }

    def echo(self, params: Dict[str, Any]) -> Dict[str, Any]:
        """Echo a message back to the client"""
        return {'echo': params.get('message', ''), 'pong': True}

    def status_check(self, params: Dict[str, Any]) -> Dict[str, Any]:
        """Return sidecar status"""
        return {
            'status': 'connected',
            'version': '0.1.0',
            'database': 'sqlite://db/smartbursar.db'
        }

    def send_response(self, response: Dict[str, Any]) -> None:
        """Send a JSON-RPC response to stdout"""
        print(json.dumps(response))
        sys.stdout.flush()

    def send_error(self, error_id: int, code: int, message: str) -> None:
        """Send a JSON-RPC error response"""
        response = {
            'jsonrpc': '2.0',
            'id': error_id,
            'error': {
                'code': code,
                'message': message
            }
        }
        self.send_response(response)

    def handle_request(self, request: Dict[str, Any]) -> None:
        """Process a single JSON-RPC request"""
        try:
            # Validate JSON-RPC 2.0 structure
            if request.get('jsonrpc') != '2.0':
                self.send_error(request.get('id', -1), -32600, 'Invalid JSON-RPC version')
                return

            request_id = request.get('id')
            method = request.get('method')
            params = request.get('params', {})

            if not method:
                self.send_error(request_id, -32600, 'Missing method')
                return

            # Dispatch to method handler
            if method not in self.methods:
                self.send_error(request_id, -32601, f'Method not found: {method}')
                return

            handler = self.methods[method]
            result = handler(params)

            response = {
                'jsonrpc': '2.0',
                'id': request_id,
                'result': result
            }
            self.send_response(response)

        except JSONRPCError as e:
            self.send_error(request.get('id', -1), e.code, e.message)
        except Exception as e:
            logger.exception(f'Error handling request: {e}')
            self.send_error(request.get('id', -1), -32603, f'Internal error: {str(e)}')

    def run(self) -> None:
        """Main loop: read JSON-RPC messages from stdin, process, send responses to stdout"""
        logger.info('SmartBursar IPC Sidecar started')
        
        try:
            for line in sys.stdin:
                line = line.strip()
                if not line:
                    continue

                try:
                    request = json.loads(line)
                    self.handle_request(request)
                except json.JSONDecodeError as e:
                    logger.error(f'JSON decode error: {e}')
                    sys.stdout.write('{"jsonrpc": "2.0", "id": -1, "error": {"code": -32700, "message": "Parse error"}}\n')
                    sys.stdout.flush()

        except KeyboardInterrupt:
            logger.info('Sidecar interrupted')
        except Exception as e:
            logger.exception(f'Sidecar error: {e}')
        finally:
            logger.info('SmartBursar IPC Sidecar stopped')


if __name__ == '__main__':
    sidecar = IPCSidecar()
    sidecar.run()
