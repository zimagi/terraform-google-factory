data "template_file" "env" {
  for_each = "var.projects"
  template = file("${path.module}/templates/env.tfvars.tpl")
  vars = {

  }
}

data "template_file" "backend_config" {
  for_each = "var.projects"
  template = file("${path.module}/templates/backend_config.tf.tpl")
  vars = {

  }
}

data "template_file" "main" {
  for_each = "var.projects"
  template = file("${path.module}/templates/main.tf.tpl")
  vars = {

  }
}

resource "local_file" "env" {
  for_each = "var.projects"
  content  = data.template_file.env[each.value.name].rendered
  filename = "${path.module}/foo.bar"
}

resource "local_file" "backend_config" {
  for_each = "var.projects"
  content  = data.template_file.backend_config[each.value.name].rendered
  filename = "${path.module}/foo.bar"
}

resource "local_file" "main" {
  for_each = "var.projects"
  content  = data.template_file.main[each.value.name].rendered
  filename = "${path.module}/foo.bar"
}