local CodeID = {
    codeName = 'ExterFramework',
    version = '1.2.0'
}
  
Citizen.CreateThread(function()
    print('[' .. CodeID.codeName .. '] v' .. CodeID.version .. ' sucessfully started!')
end)