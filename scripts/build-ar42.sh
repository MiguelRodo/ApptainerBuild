apptainer build -F r42-plain.sif r42.def \
  && apptainer build -F ar42.sif r42-add_vsc.def \
  && cp ar42.sif $HOME/sif/ar42.sif \
  && cp ar42.sif "/mnt/h/Shared drives/StoreContainer/ar42.sif"

