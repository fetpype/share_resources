# this is a script that tries to convert BOUNTI segmentations into FETA style segmentations
#bounti label		structure		feta label
#	1		Left eCSF		1
#	2		Right eCSF		1
#	3		Left GM			2
#	4		Right GM		2
#	5		Left WM			3
#	6		Right WM		3
#	7		Left LV			4
#	8		Right LV		4
#	9		Cavum			4
#	10		Brainstem		7
#	11		Left Cerebellum		5
#	12		Right Cerebellum	5
#	13		Vermis			5
#	14		Left Lentiform		6
#	15		Right Lentiform		6
#	16		Left thalamus		6
#	17		Right thalamus		6
#	18		3rd Ventricle		4
#	19		4th Ventricle		4


in=$1
subjdir=$(dirname $in)

fslmaths $in -thr 1 -uthr 1 $subjdir/label_1.nii.gz &
fslmaths $in -thr 2 -uthr 2 $subjdir/label_2.nii.gz &
fslmaths $in -thr 3 -uthr 3 $subjdir/label_3.nii.gz &
fslmaths $in -thr 4 -uthr 4 $subjdir/label_4.nii.gz &
fslmaths $in -thr 5 -uthr 5 $subjdir/label_5.nii.gz &
fslmaths $in -thr 6 -uthr 6 $subjdir/label_6.nii.gz &
fslmaths $in -thr 7 -uthr 7 $subjdir/label_7.nii.gz &
fslmaths $in -thr 8 -uthr 8 $subjdir/label_8.nii.gz &
fslmaths $in -thr 9 -uthr 9 $subjdir/label_9.nii.gz &
fslmaths $in -thr 10 -uthr 10 $subjdir/label_10.nii.gz &
fslmaths $in -thr 11 -uthr 11 $subjdir/label_11.nii.gz &
fslmaths $in -thr 12 -uthr 12 $subjdir/label_12.nii.gz &
fslmaths $in -thr 13 -uthr 13 $subjdir/label_13.nii.gz &
fslmaths $in -thr 14 -uthr 14 $subjdir/label_14.nii.gz &
fslmaths $in -thr 15 -uthr 15 $subjdir/label_15.nii.gz &
fslmaths $in -thr 16 -uthr 16 $subjdir/label_16.nii.gz &
fslmaths $in -thr 17 -uthr 17 $subjdir/label_17.nii.gz &
fslmaths $in -thr 18 -uthr 18 $subjdir/label_18.nii.gz &
fslmaths $in -thr 19 -uthr 19 $subjdir/label_19.nii.gz &
wait

#the DGM definition is different a bit since does not include internal capsule. Doing simple morphological operations to correct
fslmaths $subjdir/label_14.nii.gz -add $subjdir/label_15.nii.gz -add $subjdir/label_16.nii.gz -add $subjdir/label_17.nii.gz -bin -dilM -dilM -ero -ero -bin -mul 6 $subjdir/label_feta_6.nii.gz
wait

#renumbering and combining labels into FeTA definitions
fslmaths $subjdir/label_1.nii.gz -add $subjdir/label_2.nii.gz -bin -mul 1 $subjdir/label_feta_1.nii.gz &
fslmaths $subjdir/label_3.nii.gz -add $subjdir/label_4.nii.gz -bin -mul 2 $subjdir/label_feta_2.nii.gz &
fslmaths $subjdir/label_5.nii.gz -add $subjdir/label_6.nii.gz -bin -mul 3 $subjdir/label_feta_3.nii.gz &
fslmaths $subjdir/label_7.nii.gz -add $subjdir/label_8.nii.gz -add $subjdir/label_9.nii.gz -add $subjdir/label_18.nii.gz -add $subjdir/label_19.nii.gz -bin -mul 4 $subjdir/label_feta_4.nii.gz &
fslmaths $subjdir/label_11.nii.gz -add $subjdir/label_12.nii.gz -add $subjdir/label_13.nii.gz -bin -mul 5 $subjdir/label_feta_5.nii.gz &
fslmaths $subjdir/label_10.nii.gz -bin -mul 7 $subjdir/label_feta_7.nii.gz &
wait

#combining labels into one map
c3d $subjdir/label_feta_1.nii.gz $subjdir/label_feta_2.nii.gz $subjdir/label_feta_3.nii.gz $subjdir/label_feta_4.nii.gz $subjdir/label_feta_5.nii.gz $subjdir/label_feta_6.nii.gz $subjdir/label_feta_7.nii.gz -accum -max -endaccum -o $subjdir/FeTA_labels.nii.gz
rm $subjdir/label_*.nii.gz

exit 1

