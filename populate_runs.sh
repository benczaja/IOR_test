#!/bin/bash

################################################################
################################################################
# Change the inpformation between the two large rows of #####
access_type=POSIX
partitions=( rome genoa fat_rome fat_genoa gpu_a100 gpu_h100 )
toolchainscript="foss_2023"
nodes=( 1 2 4 8 )
ppns=( 8 )
Wtime="00:30:00"
####### ARGUMENTS #########
block_sizes=( 256m )
transfer_sizes=( 4m )
EXEC_ARGS="-F -C -e -g -w -r -K -s 1 -i 3"
###### Important Directories ###########
source_dir="/home/benjamic/IOR_TEST"
run_dir="/scratch-shared/benjamic/IOR_TEST"
################################################################
################################################################

mkdir -p $run_dir

for partition in "${partitions[@]}"
do
	case="$partition"

	for node in "${nodes[@]}"
	do
	    for ppn in "${ppns[@]}"
	    do
	
		if [ $partition = "rome" ] || [ $partition = "fat_rome" ]
		then
			ppn=128
		fi
		if [ $partition = "genoa" ] || [ $partition = "fat_genoa" ]
		then
			ppn=192
		fi
		if [ $partition = "gpu_a100" ]
		then
			ppn=72
		fi
		if [ $partition = "gpu_h100" ]
		then
			ppn=64
		fi
	
		subcase="N${node}_ppn${ppn}"

		#make the case directory
		mkdir "$run_dir/${case}_${subcase}"

		#copy executable
		rsync -a "$source_dir/ior-3.3.0" "$run_dir/${case}_${subcase}"

		#move to the case  directory
		cd "$run_dir/${case}_${subcase}"

		# Remove jobscript
		rm run.sh

		ntasks="$((node * ppn))"

		echo "#!/bin/bash" >> run.sh
		echo "  " >> run.sh
		echo "  " >> run.sh

		echo "#SBATCH --job-name=$subcase" >> run.sh
		echo "#SBATCH --ntasks=$ntasks" >> run.sh
		echo "#SBATCH --ntasks-per-node=$ppn" >> run.sh	
		echo "#SBATCH --output=run.out" >> run.sh
		echo "#SBATCH --error=run.err" >> run.sh
		echo "#SBATCH --time=$Wtime" >> run.sh
		echo "#SBATCH -p $partition" >> run.sh		
		echo "#SBATCH --exclusive" >> run.sh	

		echo " " >> run.sh
		echo " " >> run.sh

		echo "source $source_dir/$toolchainscript.sh" >> run.sh

		echo " " >> run.sh
		echo " " >> run.sh

		echo 'dtg=$( date +"%Y-%m-%d-%H-%M-%S-%N" )' >> run.sh
		echo 'echo "partition,nodes,ntasks,ntasks_per_node,block_size,transfer_size,access_type,toolchain,IO_perf,IO_type" > $dtg.output.csv' >> run.sh

		echo " " >> run.sh
		echo " " >> run.sh


		echo "block_sizes=(" ${block_sizes[@]} ")" >> run.sh
		echo "transfer_sizes=(" ${transfer_sizes[@]} ")" >> run.sh

		echo " " >> run.sh	
		echo " " >> run.sh	

		echo 'for block_size in "${block_sizes[@]}"' >> run.sh
	    echo "do" >> run.sh	
		echo 'for transfer_size in "${transfer_sizes[@]}"' >> run.sh
	    echo "do" >> run.sh	

		echo "   srun ior-3.3.0/src/ior $EXEC_ARGS -b \$block_size -t \$transfer_size -o tempout > $case.$toolchainscript.$subcase.\$block_size.output" >> run.sh
		echo '   max_read=$(grep "Max Read: " '"$case.$toolchainscript.$subcase.\$block_size.output)" >> run.sh
		echo '   max_write=$(grep "Max Write: " '"$case.$toolchainscript.$subcase.\$block_size.output)" >> run.sh
	
		echo "   echo $partition,$node,$ntasks,$ppn,\$block_size,\$transfer_size,$access_type,$toolchainscript,\$max_read,read >> \$dtg.output.csv" >> run.sh
		echo "   echo $partition,$node,$ntasks,$ppn,\$block_size,\$transfer_size,$access_type,$toolchainscript,\$max_write,write >> \$dtg.output.csv" >> run.sh


		echo "   cp \$dtg.output.csv $source_dir/output_runs " >> run.sh	
		#echo "   cp $case.$toolchainscript.$subcase.\$block_size.output $source_dir/output_runs " >> run.sh	

		echo "done" >> run.sh
		echo "done" >> run.sh
		echo " " >> run.sh



		# Submit the jobscript
		echo "Submitting jobscript from.... "
		pwd
		echo " "
		sbatch run.sh

		#move back and do it again :)
		cd $project_dir
		done
    done
done


