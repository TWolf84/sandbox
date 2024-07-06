[HKEY_LOCAL_MACHINE\SOFTWARE\Foresight\Foresight Analytics Platform\${FP_RELEASE}\Metabases\${project}]
"Name"="${project_name}"
"Driver"="POSTGRES"
"Package"="STANDARDSECURITYPACKAGE"
"AuthenticationEx"="1"
"Authentication"="1"
"Crs"=""
"Crsa"=""
"CrLP"="1"
"DebugMode"="1"
"CompileAssemblyOnly"="0"
"MetabaseConnectForAuditModeEx"=dword:00000001
"UseOldComplexPassword"=dword:00000000
"CheckDefaultDB"=dword:00000000
"CheckAuditUser"=dword:00000000
"DL"=dword:00000000
"CusEv"=dword:00000000
"UCL"=dword:00000000
"PingTimeout"=dword:0000ea60
"CachedTables"="LAST,OBJ,DAT,SEC,SD,PAR,MOD,SCSH"

[HKEY_LOCAL_MACHINE\SOFTWARE\Foresight\Foresight Analytics Platform\${FP_RELEASE}\Metabases\${project}\LogonData]
"SERVER"="8:${project.host}"
"DATABASE"="8:${project.db}.${project.scheme}"
"PROVIDER"="8:"
"CASESENSITIVE"="8:false"
"DATABASE_ONLY"="8:${project.db}"
"SCHEMA_ONLY"="8:${project.scheme}"
"PQGSSAPI"="8:false"
"PQKRBSRVNAME"="8:"
"SUPPORTBINARYPROTOCOL"="8:"
"USEUPN"="8:false"