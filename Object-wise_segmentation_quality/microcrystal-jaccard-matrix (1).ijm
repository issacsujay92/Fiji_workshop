//microcrystal-jaccard-matrix.imj
//adapted from R. Hasse
//begin with two open images, titles in Title1, Title2 variables

//setup CLIJ2, cleaning
run("CLIJ2 Macro Extensions", "cl_device=");
Ext.CLIJ2_clear();

//get images to compare
Title1 = 'test-1.tif';
Title2 = 'test-2.tif';
Ext.CLIJ2_push(Title1);
Ext.CLIJ2_push(Title2);
close();

//threshold for clean separation of objects
Ext.CLIJ2_thresholdOtsu(Title1, binary1);
Ext.CLIJ2_thresholdOtsu(Title2, binary2);

//perform lableing of connected components
Ext.CLIJ2_connectedComponentsLabelingBox(binary1, label1);
Ext.CLIJ2_connectedComponentsLabelingBox(binary2, label2);

//show label images
Ext.CLIJ2_pull(label1);
Ext.CLIJ2_pull(label2);

// generate overlap matrix
Ext.CLIJ2_generateJaccardIndexMatrix(label1, label2, jaccard_matrix);
Ext.CLIJ2_pull(jaccard_matrix);
run("Fire");
Ext.CLIJ2_pullToResultsTable(jaccard_matrix)

// determine maximum overlap per label
Ext.CLIJ2_maximumYProjection(jaccard_matrix, vector1);
Ext.CLIJ2_maximumXProjection(jaccard_matrix, vector2_t);
Ext.CLIJ2_transposeXY(vector2_t, vector2);
Ext.CLIJ2_print(vector1)
Ext.CLIJ2_print(vector2)

// put measureemnts in the respective label and show it
Ext.CLIJ2_replaceIntensities(label1, vector1, parametric_image1);
Ext.CLIJ2_replaceIntensities(label2, vector2, parametric_image2);
Ext.CLIJ2_pull(parametric_image1);
run("Fire");
Ext.CLIJ2_pull(parametric_image2);
run("Fire"); 

// clean up
Ext.CLIJ2_clear();