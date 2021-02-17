#APPLICATION LOAD BALANCER
resource "aws_lb" "alb" {
  name               = "${var.my-project-name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id, aws_default_security_group.default.id]
  subnets            = [aws_default_subnet.default_us-east-1a.id, aws_default_subnet.default_us-east-1b.id]

  enable_deletion_protection = false
}



//CLIENT TARGET GROUP
resource "aws_lb_target_group" "client" {
  name     = "${var.my-project-name}-client-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
}

//USER TARGET GROUP
resource "aws_lb_target_group" "users" {

  name     = "${var.my-project-name}-users-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
  health_check {
    path = "/api/users"
  }
}
//HTTP
resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.client.arn
  }

}

//HTTP TO USER
resource "aws_lb_listener_rule" "static" {

  listener_arn = aws_lb_listener.listener_http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.users.arn
  }

  condition {
    path_pattern {
      values = ["/api/users", "/api/task"]
    }
  }

}


//HTTPS TO CLIENT 
# resource "aws_lb_listener" "listener_https" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:acm:us-east-1:642815940637:certificate/406807ba-efb4-41c0-98c5-b0794a9b04e4"
#   // GO TO CLIENT
#   default_action {
#     type = "forward"

#     target_group_arn = aws_lb_target_group.client.arn
#   }

# }


# //HTTPS TO USER
# resource "aws_lb_listener_rule" "https_lisener" {

#   listener_arn = aws_lb_listener.listener_https.arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.users.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/users", "/api/task"]
#     }
#   }

# }