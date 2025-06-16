# os.chdir('./')
#------------------------------------------------------#
# ----------------NÃO APAGAR---------------------------#
#------------------------------------------------------#
# configurações no container = 
DATA_BASE_DIR = '/app/spark_output/db/'

schema_list_extract = [
  # 'dbo',
  'guest',
  'INFORMATION_SCHEMA',
  'sys',
  'HumanResources',
  'Person',
  'Production',
  'Purchasing',
  'Sales',
  'db_owner', 
  'db_accessadmin', 
  'db_securityadmin', 
  'db_ddladmin', 
  'db_backupoperator', 
  'db_datareader', 
  'db_datawriter', 
  'db_denydatareader', 
  'db_denydatawriter'
]
