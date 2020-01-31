<?php
$csv = array_map('str_getcsv', file('data.csv'));
$slicer = 1;
$limit = 50;

//ovoliko će se puta vrtit petlja
ini_set('max_execution_time', 0);
echo "lets go";
for($i=0; $i<ceil(count($csv)/50); ++$i) {

    //uzmi 50 komada iz arraya
    $firstFifty = array_slice($csv, $slicer, $limit);

    //petlja kroz tih 50 komada što si uzeo
    $request = [];
    for($j=0; $j<50; ++$j) {

        $request[] = [
            'event' => '$create_alias',
            'properties'    => [
                'distinct_id'   => $firstFifty[$j][1],
                'alias' => $firstFifty[$j][0],
                'token' => '3aef4b835f5e70ae38c1dd64037633b9'
            ]
        ];

    }

    //convertaj u json
    $request = json_encode($request);

    //convertaj u base64
    $request = base64_encode($request);

    //posalji na endpoint
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL,"http://api.mixpanel.com/track/");
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS,     "data=".$request);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1 );

    $result=curl_exec ($ch);
    echo $result;

    $slicer += $limit;
}

echo "We finished!";