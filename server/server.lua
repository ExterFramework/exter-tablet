local CodeID = {
    codeName = 'Exter Tablet',
    version = '2.0.0'
}

CreateThread(function()
    print(('[%s] v%s successfully started!'):format(CodeID.codeName, CodeID.version))
end)
