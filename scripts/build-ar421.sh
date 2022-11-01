apptainer build -F r421-plain.sif r421.def \
  && apptainer build -F ar421.sif r421-add_vsc.def \
  && cp ar421.sif $HOME/sif/ar421.sif \
  && cp ar421.sif "/mnt/h/Shared drives/StoreContainer/ar421.sif"

