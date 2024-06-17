# TF-Count-ForEach-Example

## Project Overview
Demo project to showcase difference between count and for_each parameter in terraform. Focus on how list/map impacts the terraform state along with count and for_each parameters.

## admin_users map
```text
admin_users = 
{
    "829f5aaf-1820-4875-bfd3-ad3fc129f95e" : "829f5aaf-1820-4875-bfd3-ad3fc129f95e"
    "cd88d4fc-a726-4a99-bde8-18c9570bd80c" : "cd88d4fc-a726-4a99-bde8-18c9570bd80c"
    ...
}
```

## count with list
If we change content of the admin_users/reader_users list, when using list the changes wont take effect. Optionally, the resource may be destroyed and rebuilded, which is something we do not want as the resource may be binded to another resource  .Terraform plan will output the following
```text
Plan: 0 to add, 0 to change, 0 to destroy.
```

## for_each with map
If we change content of the admin_users/reader_users list, when using map the changes will take the effect. Additionally, the resource wont be destroyed and rebuilded. Only the new element will be added.