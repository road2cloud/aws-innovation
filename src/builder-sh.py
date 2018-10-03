from shell import Shell
from python_terraform import *

tf = Terraform(working_dir='/Users/dimeh/Documents/workspace/SG/aws-innovation/terraform/scripts/init-vpc')
tf.init(no_color=IsFlagged)
#tf.apply(no_color=IsFlagged, refresh=False, var={'a':'b', 'c':'d'})

#sh = Shell(has_input=True)
#sh.run('ls /Users/dimeh/Documents/workspace/SG/aws-innovation/')
#print sh.output()

#ls = shell('cd .. | ls')

#for file in ls.output():
#    print file
