import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { lazy, Suspense } from 'react'
import { Toaster } from 'react-hot-toast'
import { ErrorBoundary } from './components/system/ErrorBoundary'
import { RequireAuth } from './router/RequireAuth'
import { RequireRole } from './router/RequireRole'
import { AppShell } from './components/layout/AppShell'
import { LoadingSpinner } from './components/ui/LoadingSpinner'

// Lazy loaded pages
const Login = lazy(() => import('./pages/auth/Login'))
const Status = lazy(() => import('./pages/status/Status'))
const Dashboard = lazy(() => import('./pages/dashboard/Dashboard'))
const StudentList = lazy(() => import('./pages/students/StudentList'))
const PaymentCollection = lazy(() => import('./pages/payments/PaymentCollection'))
const PaymentHistory = lazy(() => import('./pages/payments/PaymentHistory'))
const ExpenseList = lazy(() => import('./pages/expenses/ExpenseList'))
const ReportsHub = lazy(() => import('./pages/reports/ReportsHub'))

// Placeholder components for more specific routes
const UserList = () => <div className="p-10 text-center text-text-muted">User Management placeholder</div>
const Settings = () => <div className="p-10 text-center text-text-muted">System Settings placeholder</div>
const AuditLog = () => <div className="p-10 text-center text-text-muted">Audit Log placeholder</div>
const ReceiptLookup = () => <div className="p-10 text-center text-text-muted">Receipt Lookup placeholder</div>
const FeeCategories = () => <div className="p-10 text-center text-text-muted">Fee Categories placeholder</div>
const FeeStructures = () => <div className="p-10 text-center text-text-muted">Fee Structures placeholder</div>
const Cashbook = () => <div className="p-10 text-center text-text-muted">Cashbook placeholder</div>
const Banking = () => <div className="p-10 text-center text-text-muted">Banking placeholder</div>

function App() {
  return (
    <ErrorBoundary>
      <Router>
        <Suspense fallback={
          <div className="h-screen w-full flex items-center justify-center">
            <LoadingSpinner size="lg" />
          </div>
        }>
          <Routes>
            {/* Public Routes */}
            <Route path="/login" element={<Login />} />
            <Route path="/status" element={<Status />} />
            
            {/* Protected Routes */}
            <Route element={<RequireAuth />}>
              <Route element={<AppShell />}>
                <Route path="/dashboard" element={<Dashboard />} />
                
                {/* Students */}
                <Route path="/students" element={<StudentList />} />
                <Route path="/students/new" element={<StudentList />} /> {/* Stub for detail/form */}
                
                {/* Payments */}
                <Route element={<RequireRole roles={['bursar', 'super_admin']} />}>
                  <Route path="/payments" element={<PaymentCollection />} />
                  <Route path="/payments/history" element={<PaymentHistory />} />
                  <Route path="/payments/lookup" element={<ReceiptLookup />} />
                </Route>

                {/* Expenses */}
                <Route element={<RequireRole roles={['bursar', 'super_admin']} />}>
                  <Route path="/expenses" element={<ExpenseList />} />
                  <Route path="/expenses/new" element={<ExpenseList />} /> {/* Stub */}
                </Route>

                {/* Accounting */}
                <Route element={<RequireRole roles={['bursar', 'headteacher', 'super_admin']} />}>
                  <Route path="/cashbook" element={<Cashbook />} />
                  <Route path="/banking" element={<Banking />} />
                  <Route path="/banking/deposits" element={<Banking />} />
                </Route>

                {/* Academic */}
                <Route element={<RequireRole roles={['bursar', 'super_admin']} />}>
                  <Route path="/fees/categories" element={<FeeCategories />} />
                  <Route path="/fees/structures" element={<FeeStructures />} />
                </Route>
                
                {/* Reports */}
                <Route element={<RequireRole roles={['bursar', 'headteacher', 'super_admin']} />}>
                  <Route path="/reports" element={<ReportsHub />} />
                </Route>
                
                {/* System */}
                <Route element={<RequireRole roles={['super_admin']} />}>
                  <Route path="/users" element={<UserList />} />
                  <Route path="/settings" element={<Settings />} />
                </Route>
                
                {/* Audit */}
                <Route element={<RequireRole roles={['headteacher', 'super_admin']} />}>
                  <Route path="/audit" element={<AuditLog />} />
                </Route>
                
                <Route path="/" element={<Navigate to="/dashboard" replace />} />
              </Route>
            </Route>
            
            <Route path="*" element={<Navigate to="/dashboard" replace />} />
          </Routes>
        </Suspense>
      </Router>
      <Toaster position="top-right" />
    </ErrorBoundary>
  )
}

export default App
