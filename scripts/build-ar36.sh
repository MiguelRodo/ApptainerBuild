apptainer build r36-plain.sif r36.def
apptainer build -F ar36.sif r36-add_vsc.def
cp ar36.sif "/mnt/h/Shared drives/StoreContainer/ar36.sif"
cp ar36.sif $HOME/sif/ar36.sif