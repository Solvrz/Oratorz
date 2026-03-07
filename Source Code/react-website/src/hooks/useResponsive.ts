export function useResponsive() {
  const isMobile = window.innerWidth < 730;
  const isDesktop = window.innerWidth >= 730;
  return { isMobile, isDesktop };
}
