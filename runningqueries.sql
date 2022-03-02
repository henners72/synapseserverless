
-- Run against Ondemand Pool
-- Execute nocount statement first
set nocount on

--  Highlight the code below and execute

--FLAG TO EXCLUDE THIS QUERY%
SELECT GETDATE() AS CurrentDateTime, 
s.session_id, 
s.login_time, 
s.host_name, 
s.program_name,
s.login_name, 
s.nt_user_name, 
s.is_user_process,
r.database_id, -- added r.alias
DB_NAME(s.database_id) AS [database], 
s.status,
--s.reads, s.writes, s.logical_reads, s.row_count,
--c.session_id, c.net_transport, c.protocol_type, 
c.client_net_address, c.client_tcp_port, 
--c.num_writes AS DataPacketWrites ,
--c.most_recent_sql_handle,
REPLACE(REPLACE(REPLACE(t.TEXT, CHAR(10), ' '), CHAR(13), ' '), CHAR(9), ' ') as Query
FROM sys.dm_exec_sessions s
INNER JOIN sys.dm_exec_connections c
ON s.session_id = c.session_id 
INNER JOIN sys.dm_exec_requests r -- added join to sys.dm_exec_requests
ON s.session_id = r.session_id
CROSS APPLY sys.dm_exec_sql_text( c.most_recent_sql_handle ) t
WHERE s.is_user_process = 1 and
t.TEXT NOT LIKE '--FLAG TO EXCLUDE THIS QUERY%'
go 100000  

-- Alter this value to change the number of loops you can also put a wait in here if you wish.  
-- To persist results run in your monitoring tool
