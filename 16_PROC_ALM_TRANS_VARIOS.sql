/*
PROCEDIMIENTOS ALMACENADOS TRANSACCIONALES
*/


--Consultar sesiones activas:
SELECT *
FROM sys.dm_exec_sessions --sesiones activas en el servidor
-----------------------------------------------------------------------------------
SELECT
    session_id,
    login_name, --nombre del usuario
    host_name, --nombre del host
    program_name,
    status,
    last_request_start_time 
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;

-----------------------------------------------------------------------------------
--Identificar bloqueos (locks)
SELECT *
FROM sys.dm_tran_locks

-----------------------------------------------------------------------------------
--Identificar transacciones abiertas
SELECT *
FROM sys.dm_tran_active_transactions

-----------------------------------------------------------------------------------
--Revisar transacciones largas
SELECT *
FROM sys.dm_tran_database_transactions
WHERE database_transaction_begin_time < DateADD(MINUTE, -5, GetDate())

-----------------------------------------------------------------------------------
--Identificar sesiones bloqueadas
SELECT *
FROM sys.dm_os_waiting_tasks
WHERE blocking_session_id IS NOT NULL

-----------------------------------------------------------------------------------
--Analizar el uso de la memoria por sesión
SELECT
    session_id,
    memory_usage,
    total_scheduled_time,
	total_elapsed_time
FROM sys.dm_exec_sessions
WHERE memory_usage > 0

-----------------------------------------------------------------------------------
--Identificar consultas con alto consumo de CPU
SELECT
    qs.total_worker_time / qs.execution_count AS [Promedio de CPU],
    qs.execution_count,
    t.text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) t
ORDER BY 3 DESC

