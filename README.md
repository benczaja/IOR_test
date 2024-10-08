# IOR Benchmark
Sources used for this benchmark 
- https://ior.readthedocs.io/en/latest/userDoc/tutorial.html
- https://cug.org/5-publications/proceedings_attendee_lists/2007CD/S07_Proceedings/pages/Authors/Shan/Shan_paper.pdf

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
