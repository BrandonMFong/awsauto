resource "aws_iam_role" "automation-role-v2" {
  name = "automation-role-v2"

  assume_role_policy = <<EOF
{
	"Version" : "2012-10-17",
	"Statement": [
	{
		"Sid": "AllowEc2ToUseThisRole",
		"Action": "sts:AssumeRole",
		"Principal": {
			"Service": "ec2.amazonaws.com"
		},
		"Effect": "Allow"
	}]
}
EOF
}

resource "aws_iam_role_policy_attachment" "automation-role-policy-v2" {
  role       = aws_iam_role.automation-role-v2.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
