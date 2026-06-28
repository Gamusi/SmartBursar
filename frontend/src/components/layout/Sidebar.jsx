import React from 'react'
import { Link, useLocation } from 'react-router-dom'
import { NAVIGATION } from '../../config/navigation'
import { useAuthStore } from '../../store/authStore'
import { useInstitutionStore } from '../../store/institutionStore'
import { LogOut } from 'lucide-react'
import { Logo } from '../ui/Logo'

export function Sidebar() {
  const location = useLocation()
  const role = useAuthStore(s => s.role)
  const user = useAuthStore(s => s.user)
  const logout = useAuthStore(s => s.logout)
  const institutionName = useInstitutionStore(s => s.name)
  const activeTerm = useInstitutionStore(s => s.activeTerm)

  const filteredNav = NAVIGATION.map(group => ({
    ...group,
    items: group.items.filter(item => item.roles.includes('all') || item.roles.includes(role))
  })).filter(group => group.items.length > 0)

  return (
    <aside className="w-60 h-full bg-surface border-r border-border flex flex-col pt-4">
      {/* School Logo & Name */}
      <div className="px-6 mb-8 space-y-1">
        <Logo size="md" />
        <p className="text-[10px] text-text-muted mt-0.5 truncate uppercase tracking-widest">{institutionName}</p>
      </div>

      {/* Navigation Groups */}
      <nav className="flex-1 overflow-y-auto px-3 space-y-6 pb-6">
        {filteredNav.map((group, idx) => (
          <div key={idx} className="space-y-1">
            {group.group && (
              <h2 className="px-3 text-[10px] font-bold text-text-muted uppercase tracking-widest mb-2">
                {group.group}
              </h2>
            )}
            {group.items.map((item, itemIdx) => {
              const Icon = item.icon
              const isActive = location.pathname === item.path
              return (
                <Link
                  key={itemIdx}
                  to={item.path}
                  className={`flex items-center gap-3 px-3 py-2 rounded-md text-sm transition-colors ${
                    isActive 
                    ? 'bg-primary text-white' 
                    : 'text-text-primary hover:bg-background'
                  }`}
                >
                  <Icon size={18} className={isActive ? 'text-white' : 'text-text-muted'} />
                  <span className="font-medium">{item.label}</span>
                </Link>
              )
            })}
          </div>
        ))}
      </nav>

      {/* Bottom Footer Section */}
      <div className="p-4 border-t border-border bg-background/50 space-y-4">
        {/* Active Term Indicator */}
        <div className="bg-surface rounded-md p-2 border border-border">
          <p className="text-[9px] font-bold text-text-muted uppercase tracking-tighter">Current Term</p>
          <div className="flex items-center justify-between mt-1">
            <span className="text-xs font-semibold">{activeTerm || 'Term 1, 2025'}</span>
            <span className="bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400 text-[8px] font-bold px-1.5 py-0.5 rounded uppercase">Open</span>
          </div>
        </div>

        {/* User Info & Logout */}
        <div className="flex items-center justify-between">
          <div className="min-w-0">
            <p className="text-xs font-bold text-text-primary truncate">{user?.full_name || 'Sarah Nakato'}</p>
            <p className="text-[10px] text-text-muted truncate capitalize">{role || 'Bursar'}</p>
          </div>
          <button 
            onClick={() => logout()}
            className="p-1.5 text-text-muted hover:text-danger hover:bg-red-50 dark:hover:bg-red-900/10 rounded-md transition-colors"
            title="Logout"
          >
            <LogOut size={16} />
          </button>
        </div>
      </div>
    </aside>
  )
}

