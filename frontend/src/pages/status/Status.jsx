import { useState, useEffect } from 'react'
import { Card } from '../../components/ui/Card'
import { Button } from '../../components/ui/Button'

export default function Status() {
  const [status, setStatus] = useState('checking...')
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    checkConnection()
  }, [])

  const checkConnection = async () => {
    try {
      setLoading(true)
      
      // Try to use Tauri IPC
      if (window.__TAURI__) {
        const { invoke } = await import('@tauri-apps/api/core')
        const response = await invoke('ipc_call', {
          method: 'status.check',
          params: {}
        })
        
        setStatus('connected')
        setMessage(JSON.stringify(response, null, 2))
      } else {
        // Fallback if Tauri not available (local dev)
        setStatus('tauri-unavailable')
        setMessage('Tauri API not available. Run with: bun tauri dev')
      }
    } catch (error) {
      setStatus('error')
      setMessage(error.message || String(error))
    } finally {
      setLoading(false)
    }
  }

  const testPing = async () => {
    try {
      setLoading(true)
      const { invoke } = await import('@tauri-apps/api/core')
      const response = await invoke('ipc_call', {
        method: 'ping.echo',
        params: { message: 'Hello from React!' }
      })
      
      setMessage('Ping response: ' + JSON.stringify(response, null, 2))
    } catch (error) {
      setMessage('Ping failed: ' + error.message)
    } finally {
      setLoading(false)
    }
  }

  const statusColor = {
    'checking...': 'text-yellow-500',
    'connected': 'text-green-500',
    'error': 'text-red-500',
    'tauri-unavailable': 'text-yellow-500'
  }[status] || 'text-gray-500'

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-dark via-surface to-primary-dark flex items-center justify-center p-4">
      <Card className="max-w-md w-full">
        <div className="space-y-6">
          {/* Header */}
          <div className="text-center">
            <h1 className="text-3xl font-syne font-extrabold text-text-primary mb-2">
              SmartBursar
            </h1>
            <p className="text-sm text-text-muted">IPC Connection Test</p>
          </div>

          {/* Status box */}
          <div className="bg-surface-hover p-4 rounded-lg border border-border">
            <p className="text-xs text-text-muted uppercase tracking-widest mb-2">Connection Status</p>
            <p className={`text-2xl font-bold ${statusColor}`}>
              {status}
            </p>
          </div>

          {/* Message output */}
          {message && (
            <div className="bg-black/20 p-4 rounded-lg font-mono text-xs text-text-secondary max-h-48 overflow-y-auto">
              <pre>{message}</pre>
            </div>
          )}

          {/* Buttons */}
          <div className="flex gap-2">
            <Button 
              variant="secondary" 
              className="flex-1" 
              onClick={checkConnection}
              disabled={loading}
            >
              {loading ? 'Testing...' : 'Check Status'}
            </Button>
            <Button 
              className="flex-1" 
              onClick={testPing}
              disabled={loading}
            >
              {loading ? 'Testing...' : 'Test Ping'}
            </Button>
          </div>

          {/* Info */}
          <div className="text-xs text-text-muted space-y-1">
            <p>📋 <strong>IPC Protocol:</strong> JSON-RPC 2.0</p>
            <p>🚀 <strong>Transport:</strong> Tauri invoke → stdin/stdout</p>
            <p>🐍 <strong>Backend:</strong> Python sidecar.py</p>
          </div>
        </div>
      </Card>
    </div>
  )
}
