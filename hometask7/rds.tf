
resource "aws_db_instance" "Lab7" {
    identifier = "mysqldb"
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    name = "dbtest"
    username = "testuser"
    password = var.password
    storage_type = "gp2"
    allocated_storage = 20
    parameter_group_name = "default.mysql5.7"
    port = "3306"
    #db_subnet_group_name = aws_vpc.dev.id
    skip_final_snapshot = false
    
    tags = {
      Name = "Demo MySQL RDS Instance"
    }
}