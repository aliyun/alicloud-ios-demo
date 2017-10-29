interface{"TestClass"}
function output(self)
print('[TestClass] This is replaced before output.')
self:ORIGoutput()
print('[TestClass] This is replaced after output.')
end
