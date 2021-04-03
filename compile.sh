#!/bin/bash
module unload matlab
module load matlab/2017a


cat > build.m <<END
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('/N/u/brlife/git/spm12'))
addpath(genpath('/N/u/brlife/git/mba'))
addpath(genpath('/N/u/hayashis/git/vistasoft'))
addpath(genpath('/N/u/dnbulloc/Carbonate/gitProjects/app-tractDensityMasks/wma_tools'))
mcc -m -R -nodisplay -d compiled main
exit
END

matlab -nodisplay -nosplash -r build && rm build.m

log=compiled/commit_ids.txt
true > $log
echo "/N/u/dnbulloc/Carbonate/gitProjects/app-tractDensityMasks/wma_tools" >> $log
(cd /N/u/dnbulloc/Carbonate/gitProjects/app-tractDensityMasks/wma_tools && git log -1) >> $log
echo "/N/u/brlife/git/jsonlab" >> $log
(cd /N/u/brlife/git/jsonlab && git log -1) >> $log
echo "/N/u/brlife/git/mba" >> $log
(cd /N/u/brlife/git/mba && git log -1) >> $log
echo "/N/u/hayashis/git/vistasoft" >> $log
(cd /N/u/hayashis/git/vistasoft && git log -1) >> $log





