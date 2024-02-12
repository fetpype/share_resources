# this is a script that tries to convert dHCP segmentations into FETA style segmentations. This is imperfect since there are anatomical differences in the eCSF label and the amygdala is not precisely split between GM WM. Use with caution
#dhcp label		structure		feta label
#	1		eCSF			1
#	2		GM			2
#	3		WM			3
#	4		background		0
#	5		ventricle		4
#	6		cerebellum		5
#	7		DGM			6
#	8		brainstem		7
#	9		amygdala		- part of 2 GM


scriptdir=$(dirname $0)
echo $scriptdir
in=$1
subjdir=$(dirname $in)
filename=$(basename $in .nii.gz)

fslmaths $in -thr 1 -uthr 1 -bin $subjdir/label_1.nii.gz &
fslmaths $in -thr 2 -uthr 2 -bin $subjdir/label_2.nii.gz &
fslmaths $in -thr 3 -uthr 3 -bin $subjdir/label_3.nii.gz &
fslmaths $in -thr 4 -uthr 4 -bin $subjdir/label_4.nii.gz &
fslmaths $in -thr 5 -uthr 5 -bin $subjdir/label_5.nii.gz &
fslmaths $in -thr 6 -uthr 6 -bin $subjdir/label_6.nii.gz &
fslmaths $in -thr 7 -uthr 7 -bin $subjdir/label_7.nii.gz &
fslmaths $in -thr 8 -uthr 8 -bin $subjdir/label_8.nii.gz &
fslmaths $in -thr 9 -uthr 9 -bin $subjdir/label_9.nii.gz &
wait

#create a modified label of the ventricles using a template image registration and a manually drawn mask (to correct for cistern and 3rd ventricle differences)
flirt -in $scriptdir/dhcp_templateimage.nii.gz -dof 12 -ref $in -omat $subjdir/dhcp2sub.mat
flirt -in $scriptdir/dhcp_ventriclemask.nii.gz -ref $in -applyxfm -init $subjdir/dhcp2sub.mat -out $subjdir/label_4_correction.nii.gz 

#renumbering and combining labels into FeTA definitions
fslmaths $subjdir/label_1.nii.gz -bin -mul 1 $subjdir/label_feta_1.nii.gz &
fslmaths $subjdir/label_2.nii.gz -add $subjdir/label_9.nii.gz -bin -mul 2 $subjdir/label_feta_2.nii.gz &
fslmaths $subjdir/label_3.nii.gz -bin -mul 3 $subjdir/label_feta_3.nii.gz &
fslmaths $subjdir/label_5.nii.gz -bin -add $subjdir/label_4_correction.nii.gz -bin -mul 4 $subjdir/label_feta_4.nii.gz &
fslmaths $subjdir/label_6.nii.gz -bin -mul 5 $subjdir/label_feta_5.nii.gz &
fslmaths $subjdir/label_7.nii.gz -bin -mul 6 $subjdir/label_feta_6.nii.gz &
fslmaths $subjdir/label_8.nii.gz -bin -mul 7 $subjdir/label_feta_7.nii.gz &
wait

#combining labels into one map
c3d $subjdir/label_feta_1.nii.gz $subjdir/label_feta_2.nii.gz $subjdir/label_feta_3.nii.gz $subjdir/label_feta_4.nii.gz $subjdir/label_feta_5.nii.gz $subjdir/label_feta_6.nii.gz $subjdir/label_feta_7.nii.gz -accum -max -endaccum -o $subjdir/"$filename"_FeTA_labels.nii.gz

rm $subjdir/label_*.nii.gz
rm $subjdir/dhcp2sub.mat

exit 1

