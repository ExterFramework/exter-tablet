-- Backward compatibility helper.
-- Keep this file so external resources that include it do not break.

function TabletNotify(message, msgType)
    Notify(message, msgType)
end
