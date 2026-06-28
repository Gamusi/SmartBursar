import React, { useState } from 'react'
import { useForm } from 'react-hook-form'
import { useNavigate, useLocation } from 'react-router-dom'
import { useAuthStore } from '../../store/authStore'
import { login as loginApi } from '../../api/users'
import { Input } from '../../components/ui/Input'
import { Button } from '../../components/ui/Button'
import { toast } from 'react-hot-toast'
import { Logo } from '../../components/ui/Logo'

export default function Login() {
  const [loading, setLoading] = useState(false)
  const { register, handleSubmit, formState: { errors } } = useForm()
  const login = useAuthStore(s => s.login)
  const navigate = useNavigate()
  const location = useLocation()
  
  const from = location.state?.from?.pathname || '/dashboard'

  const onSubmit = async (data) => {
    setLoading(true)
    try {
      const response = await loginApi(data.username, data.password)
      login(response.user, response.token)
      toast.success(`Welcome back, ${response.user.full_name}!`)
      navigate(from, { replace: true })
    } catch (err) {
      toast.error(err.message || 'Invalid username or password')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center p-4" style={{ backgroundColor: '#CDDFC3' }}>
      <div className="max-w-md w-full">
        {/* Logo / Branding */}
        <div className="flex flex-col items-center mb-6 text-center">
          <Logo size="xl" layout="vertical" className="mb-2" />
          <p className="text-text-muted mt-2 font-medium text-sm" style={{ fontFamily: 'Arial, sans-serif' }}>School Financial Management System</p>
        </div>

        {/* Login Card */}
        <div className="p-8 rounded-2xl shadow-xl border border-border bg-[#DBE9D9] dark:bg-surface">
          <h2 className="text-xl font-bold text-text-primary mb-6">Sign In</h2>
          
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
            <Input
              label="Username"
              placeholder="e.g. bursar"
              autoComplete="username"
              inputClassName="bg-[#F4F8F3] focus:bg-white dark:bg-surface-hover dark:focus:bg-surface"
              {...register('username', { required: 'Username is required' })}
              error={errors.username?.message}
            />

            <Input
              label="Password"
              type="password"
              placeholder="••••••••"
              autoComplete="current-password"
              inputClassName="bg-[#F4F8F3] focus:bg-white dark:bg-surface-hover dark:focus:bg-surface"
              {...register('password', { required: 'Password is required' })}
              error={errors.password?.message}
            />

            <div className="pt-2">
              <Button 
                type="submit" 
                className="w-full py-3 text-base" 
                loading={loading}
              >
                Enter System
              </Button>
            </div>
          </form>

          {/* Footer Info */}
          <div className="mt-8 pt-6 border-t border-border flex flex-col items-center gap-2">
            <div className="flex gap-4">
               <span className="text-[10px] text-text-muted italic">VITE_MOCK_MODE: ON</span>
            </div>
          </div>
        </div>
        
        <p className="text-center text-[11px] text-text-muted mt-8">
          &copy; 2025 A-Von Software &bull; v1.0.0-alpha
        </p>
      </div>
    </div>
  )
}

