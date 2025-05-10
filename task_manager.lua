local TaskManager = {Tasks = {}, Debug = true}

function TaskManager:AddTask(Name, IsRunning, Callback)
    if typeof(Name) ~= 'string' then 
        return warn('ERROR Arg #1:', Name, 'is a', typeof(Name), '(expected string)')
    elseif typeof(Callback) ~= 'function' then 
        return warn('ERROR Arg #2:', Name, 'is a', typeof(Name), '(expected function)')
    end 

    TaskManager.Tasks[Name] = {}
    TaskManager.Tasks[Name]['Callback'] = Callback 
    if self.Debug then 
        print('task added', Name, Callback)
    end 

    if IsRunning then 
        if self.Debug then 
            print('task running')
        end 

        TaskManager.Tasks[Name]['Task'] = task.spawn(function()
            pcall(Callback)
        end)
    end 
end 

function TaskManager:RunTask(Name, NewCallback)
    if typeof(Name) ~= 'string' then 
        return warn('ERROR Arg #1:', Name, 'is a', typeof(Name), '(expected string)')
    elseif Name and TaskManager.Tasks[Name] == nil then 
        return warn('ERROR Arg #2:', Name, 'is not existing Task')
    elseif NewCallback and typeof(NewCallback) ~= 'function' then 
        return warn('ERROR Arg #3: New callback value is', typeof(Name), '(expected function)')
    end  

    if NewCallback then 
        if self.Debug then 
            print('added new callback for', Name, NewCallback)
        end 
        TaskManager.Tasks[Name]['Callback'] = NewCallback
    end 

    TaskManager.Tasks[Name].Task = task.spawn(function()
        pcall(TaskManager.Tasks[Name].Callback)
    end)
end 

function TaskManager:StopTask(Name)
    if typeof(Name) ~= 'string' then 
        return warn('ERROR Arg #1:', Name, 'is a', typeof(Name), '(expected string)')
    elseif Name and TaskManager.Tasks[Name] == nil then 
        return warn('ERROR Arg #2:', Name, 'is not existing Task')
    end 

    TaskManger[Name]['Task'] = nil 
end 


return TaskManager
