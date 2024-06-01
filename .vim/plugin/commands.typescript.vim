if exists("g:mayhem_loaded_typescript_commands")
  finish
endif
let g:mayhem_loaded_typescript_commands = 1


" export const EmptyComponent_Basic = ({
"   className = '',
" }: {
"   className?: string,
" }) => {
"   return (
"     <div className={className}></div>
"   );
" };

" export const EmptyComponent_Styled = styled(({
"   className = '',
" }: {
"   className?: string,
" }) => {
"   return (
"     <div className={className}></div>
"   );
" })`
" `;
" export const EmptyComponent_WithChildren = ({
"   className = '',
"   children,
" }: React.PropsWithChildren<{
"   className?: string,
" }>) => {
"   return (
"     <div className={className}>{children}</div>
"   );
" };

