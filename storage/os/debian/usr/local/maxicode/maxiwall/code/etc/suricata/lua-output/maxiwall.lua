-- Author: Arafat Ali
-- This is suricata custom report that has IPS capability
-- This report will use maxiwall wrapper

-- This is a popen wrapper function used to handle and destroy file handler for readline output command
function io.popen_read_line(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*line")
    handle:close()
    return result
end

-- This is a popen wrapper function used to handle and destroy file handler for readall output command
function io.popen_read_all(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*all")
    handle:close()
    return result
end

-- This is a popen wrapper function used to handle and destroy file handler (no output to return)
function io.popen_x(cmd)
    local handle = io.popen(cmd)
    handle:close()
end

-- This is an OS specific function useful to sleep suricata statement in this script. Similar to sleep(n) in bash
function sleep(n)
    os.execute("sleep " .. tonumber(n))
end

-- This function is used whether to display log function in suricata.log or not (For Debug)
-- To enable set enable_log = true
function logNotice(log_str)
    if enable_log == true then
        log_pattern = "Maxiwall: " .. log_str
        SCLogNotice(log_pattern)
        -- This is a independent script log file (that does not depend on the suricata.log)
        if enable_self_log == true then
            maxiwall_log:write(log_pattern .. "\n")
            maxiwall_log:flush()
        end
    end
end

-- This is an init function that is requires by Suricata to define what data need to display
-- We are interested with packet with alerts
function init (args)
    local needs = {}
    needs["type"] = "packet"
    needs["filter"] = "alerts"
    return needs
end

-- This is the setup function where we declare and assign all variables to be used for suricata to process the report
function setup (args)
    -- The main Maxiwall lua log (For debugging)
    maxiwall_log = assert(io.open(SCLogPath() .. "/" .. "maxiwall.log", "a"))
    -- The main Maxiwall alert log (will show both critical and non critical alert)
    maxiwall_alert_log = assert(io.open(SCLogPath() .. "/" .. "maxiwall-alert.log", "a"))
    -- This will get the public IPv4 for the current host
    local_ipv4 = tostring(io.popen_read_line("maxiwall cmd get-local-ipv4"))
    -- This will get the public IPv6 for the current host
    local_ipv6 = tostring(io.popen_read_line("maxiwall cmd get-local-ipv6"))
    -- This is a report count
    report_count = 0
    -- This variable hold the value of a suspected IP in log report
    suspected_ip = ""
end

-- This function will be run multiple times by suricata to produce dynamic report
-- It obtains some variable from suricata function begin with SCFunctionName()
-- When declaring variable from suricata function, the variable name can be anything but must be in order of its existence
-- Always refer to documentation about suricata function: https://suricata.readthedocs.io/en/latest/lua/lua-functions.html
function log(args)
    -- Obtain the timestring value from suricata function
    time_string = SCPacketTimeString()
    -- Obtain the rule signature ID, rule revision and rule group ID from suricata function
    rule_sid, rule_rev, rule_gid = SCRuleIds()
    -- Obtain the ip version, source IP, destination IP, IP protocol, source port and destination port from suricata function
    ip_ver, src_ip, dst_ip, protocol, src_port, dst_port = SCPacketTuple()
    -- Obtain the rule triggered message from suricata function (this value normally contain series of words)
    msg = SCRuleMsg()
    -- Obtain the rule class and rule priority from suricata function
    class, priority = SCRuleClass()
    -- Sometimes triggered rule does not have rule class, if so assign class to unknown string to display in alert report
    if class == nil then
        class = "unknown"
    end

    -- If the source IP is a local IPv4, display it as LOCAL_IPV4 in alert report and assign the suspected IP as the destination IP
    if src_ip == local_ipv4 then
        src_ip = "LOCAL_IPV4"
        suspected_ip = dst_ip
        -- else if the source IP is a local IPv6, display it as LOCAL_IPV6 in alert report and assign the suspected IP as the destination IP
    elseif src_ip == local_ipv6 then
        src_ip = "LOCAL_IPV6"
        suspected_ip = dst_ip
    end
    -- If the destination IP is a local IPv4, display it as LOCAL_IPV4 in alert report and assign the suspected IP as the source IP
    if dst_ip == local_ipv4 then
        dst_ip = "LOCAL_IPV4"
        suspected_ip = src_ip
        -- else if the destination IP is a local IPv6, display it as LOCAL_IPV6 in alert report and assign the suspected IP as the source IP
    elseif dst_ip == local_ipv6 then
        dst_ip = "LOCAL_IPV6"
        suspected_ip = src_ip
    end

    -- Building report string template
    str_report = "|N: " .. report_count .. " |PRIO: " .. priority .. " |TIME: " .. time_string ..
            " |SOURCE: " .. src_ip .. " |SP: " .. src_port .. " |TARGET: " .. dst_ip ..
            " |TP: " .. dst_port .. " |G: " .. rule_gid .. " |S: " .. rule_sid .. " |R: " .. rule_rev ..
            " |CLASS: " .. class .. " |MSG: " .. '"' .. msg .. '"' .. "\n"

    -- Write the report string to file in maxiwall_alert_log
    maxiwall_alert_log:write(str_report)
    maxiwall_alert_log:flush()

    -- Increase report count to 1
    report_count = report_count + 1;
end

-- This is the clean function
function deinit (args)
    SCLogInfo("Alerted " .. report_count .. " times");
    io.close(maxiwall_log)
    io.close(maxiwall_alert_log)
end