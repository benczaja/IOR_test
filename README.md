# IOR Benchmark
Sources used for this benchmark 
- https://ior.readthedocs.io/en/latest/userDoc/tutorial.html
- https://cug.org/5-publications/proceedings_attendee_lists/2007CD/S07_Proceedings/pages/Authors/Shan/Shan_paper.pdf


### Parameters used for the test

-e -g -K -i

Currently we are running IOR with these options
```
    -a API POSIX|MPIIO|HDF5
    -w (WriteFile File) indicate whether to measure the write operation
    -r (ReadFile File) indicate whether to measure the read operation
    -s 1 (SegmentCount) decides the number of datasets in the file
    -F (filePerProc) I/O one file per process
    -C (reorderTasksConstant) changes task ordering to n+1 ordering for readback. This helps defend against node memory (block buffer cache) effects when reading after write.
    -e (fsync) perform fsync upon POSIX write close. Stops effects of the page cache on write performance. Forces the dirty pages we just wrote to flush out to GPFS
    -g (intraTestBarriers) use barriers between open, write/read, and close
    -K (keepFileWithError) keep error-filled file(s) after data-checking
    -b (BlockSize) represents the size of the subdomain of the dataset stored on each processor
    -t (TransferSize) the I/O transaction size used to transfer data from memory to the data file, which may require multiple transfers per segment to copy the entire “BlockSize” to the data file.
    -i 3 (numerber of repetitions) number of repetitions of test
```


## IOR single node benchmark for GPFS (Snellius)

### Finding the correct blocksize and transfersize

#### Rome
<img src="plots/rome_heatmap_blockvtransfer.png" width="700"/>

#### Fat Rome
<img src="plots/fat_rome_heatmap_blockvtransfer.png" width="700"/>

#### Fat Genoa
<img src="plots/genoa_heatmap_blockvtransfer.png" width="700"/>

#### Fat Genoa
<img src="plots/fat_genoa_heatmap_blockvtransfer.png" width="700"/>

#### GCN (A100)
<img src="plots/gpu_a100_heatmap_blockvtransfer.png" width="700"/>

#### GCN (H100)
<img src="plots/gpu_h100_heatmap_blockvtransfer.png" width="700"/>



#### Varation of blocksize per transfersize 4MiB
<img src="plots/IO_per_blocksize_segment1_transfersize4.0M.png" width="700"/>

#### Varation of transfersize per blocksizesize 8GiB
<img src="plots/IO_per_transfersize_segment1_blocksize8.0G.png" width="700"/>

### Choosing block_size = 8GiB, transfer_size 4MiB, 8 ntasks-per-node
<img src="plots/all_nodes_bs8GiB_ts4MiB_FS_64GiB_1node_8ppn.png" width="700"/>

# Variation of ntasks-per-node
<img src="plots/IO_ntasks_per_node_1node_ts4.0MiB_8.0GiB.png" width="700"/>

# Variation of nnodes (ntasks-per-node = 8 )
<img src="plots/IO_per_node_8ppn_ts4.0MiB_8.0GiB.png" width="700"/>
