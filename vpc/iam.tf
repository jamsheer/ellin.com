resource "aws_iam_instance_profile" "web_profile" {
    name = "web_profile"
    roles = ["${aws_iam_role.web_role.name}"]
}

resource "aws_iam_role" "web_role" {
    name = "web_role"
    path = "/"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}