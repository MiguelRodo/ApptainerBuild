apptainer build -F r41-plain.sif r41.def
apptainer build -F ar41.sif r41-add_vsc.def
cp ar41.sif "/mnt/h/Shared drives/StoreContainer/ar41.sif"
cp ar41.sif $HOME/sif/ar41.sif
