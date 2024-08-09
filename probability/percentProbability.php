<?php
function weightedRandomSelection(array $values, array $percentages) {
    // Check if both arrays have the same length
    if (count($values) !== count($percentages)) {
        throw new InvalidArgumentException('Values and percentages arrays must have the same length.');
    }
    
    // Check if percentages sum up to 1.00000
    $totalPercentage = array_sum($percentages);
    if (abs($totalPercentage - 1.00000) > 0.00001) {
        throw new InvalidArgumentException('Percentages must sum up to 1.00000.');
    }

    // Generate a random number between 0 and 1
    $random = mt_rand() / mt_getrandmax();

    // Determine which value corresponds to the random number
    $cumulativePercentage = 0;
    foreach ($values as $index => $value) {
        $cumulativePercentage += $percentages[$index];
        if ($random <= $cumulativePercentage) {
            return $value;
        }
    }

    // Fallback (should not be reached if percentages sum to 1.00000)
    throw new RuntimeException('Selection failed.');
}

// Example usage
$values = ['apple', 'banana', 'cherry'];
$percentages = [0.98990, 0.01000, 0.00010];  // Percentages must sum to 100

$list['apple'] = 0;
$list['banana'] = 0;
$list['cherry'] = 0;
$selectedValue='';
for($i = 0; $i<100000; $i++){
$selectedValue = weightedRandomSelection($values, $percentages);
$list[$selectedValue]++;
if($selectedValue == "cherry"){
    echo "\n Cherry @ $i ";
}
//echo " \n Selected value: " . $selectedValue;
}

echo "\n";
print_r($list);
echo "\n iteration = $i";
echo "\n Apple = ".$list['apple']/($i/100)."%";
echo "\n Banana = ".$list['banana']/($i/100)."%";
echo "\n Cherry = ".$list['cherry']/($i/100)."%";
echo "\n".$list['apple'] + $list['banana'] + $list['cherry'];

?>