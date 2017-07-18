
    DiscriminativeLowpassFiltering_with_CLAHE.m is the MATLAB implementation of my Masters thesis titled  
    "Contrast enhancement with the noise removal by a discriminative filtering process", Concordia 
    University, Montreal, Canada, 2012.
    
    In this thesis, a novel approach of low-pass filtering is developed based on multiple stages of median 
    filtering and threshold based image clustering. The input of the filtering algorithm is a low contrast 
    image which is first enhanced by a variant of histogram equalization (CLAHE). Then the developed 
    algorithm detects different levels of noisy regions in that enhanced image and selectively apply low-pass
    filtering over those regions based on their noise levels while protecting high frequency edge regions. In
    that way,the algorithm is able to discriminatively smooth noisy pixels by maintaining preservation of 
    edges. For further understanding, find the thesis at the following 
    link: http://spectrum.library.concordia.ca/974797/1/Nahar_MASc_F2012.pdf
    
    This filtering algorithm was later on implemented on FPGA (Field Programmable Logic Array) by 
    Roger Olivé Muñiz in 2013 as part of his bachelor degree capstone project titled "FPGA Implementation 
    of a Contrast Enhancement Algorithm" in collaboration with Concordia University and 
    Universitate Politècnica de Catalunya.You can find the detail implementation and corresponding 
    VHDL codes in his report on the following 
    link: http://upcommons.upc.edu/bitstream/handle/2099.1/19228/report_final.pdf
    
