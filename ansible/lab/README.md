# Storage config

Currently all storage proviosning happens in the system context.

So whenever a virsh command is executed, make sure that you are in the right context.

'virsh -c qemu:///system' is excuted in the system context and the result can only been seen, when you are logged in as root.

'virsh -c qemu:///session' is excuted in the current user context and the result can only been seen, when you are logged in as a user.

