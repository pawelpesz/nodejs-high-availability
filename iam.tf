data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ssm_managed_instance" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "assume_role" {
  name_prefix        = "${var.base_name}-role-"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "instance" {
  name_prefix = "${var.base_name}-instance-profile-"
  role        = aws_iam_role.assume_role.name
}

resource "aws_iam_role_policy" "instance" {
  name_prefix = "${var.base_name}-policy-"
  role        = aws_iam_role.assume_role.id
  policy      = data.aws_iam_policy.ssm_managed_instance.policy
}
