// Theme-optimized logo component
import React from 'react'
import symbolPrimary from '../../assets/logo1-symbolprimary.png'
import wordmarkPrimary from '../../assets/logo2-wordmarkprimary.png'

export function LogoSymbol({ className = "h-8 w-auto", symbolWithBg = false }) {
  const containerClass = symbolWithBg
    ? "p-1.5 bg-background dark:bg-surface border border-border rounded-xl shadow-sm flex items-center justify-center"
    : "flex items-center justify-center"

  return (
    <div className={containerClass}>
      <img
        src={symbolPrimary}
        alt="SmartBursar Symbol"
        className={className}
      />
    </div>
  )
}

export function Logo({
  showSymbol = true,
  showText = true,
  size = "md",
  symbolWithBg = false,
  layout = "horizontal",
  className = ""
}) {
  // TO MAKE THE LOGOS BIGGER: Edit the Tailwind height classes below.
  // For example, change symbol 'xl' to "h-36" or "h-40" and wordmark 'xl' to "h-18" or "h-20".

  const symbolHeightClass = {
    sm: "h-6",
    md: "h-8",
    lg: "h-16",
    xl: "h-44" // Symbol size on login page (e.g. increase to "h-36" or "h-44" for a larger look)
  }[size] || "h-8"

  const wordmarkHeightClass = {
    sm: "h-5",
    md: "h-6",
    lg: "h-10",
    xl: "h-34" // Wordmark size on login page (e.g. increase to "h-18" or "h-24" for a larger look)
  }[size] || "h-6"

  const flexClass = layout === "vertical"
    ? "flex flex-col items-center gap-0.1 text-center" // 👈 Edit this gap (e.g., gap-1 or gap-0.5) to bring the symbol and wordmark closer together
    : "flex items-center gap-3"

  return (
    <div className={`${flexClass} ${className}`}>
      {showSymbol && (
        <LogoSymbol className={`${symbolHeightClass} w-auto object-contain`} symbolWithBg={symbolWithBg} />
      )}
      {showText && (
        <div className="flex items-center select-none">
          <img
            src={wordmarkPrimary}
            alt="SmartBursar"
            className={`${wordmarkHeightClass} w-auto object-contain`}
            style={{ fontFamily: 'Arial, sans-serif' }}
          />
        </div>
      )}
    </div>
  )
}
