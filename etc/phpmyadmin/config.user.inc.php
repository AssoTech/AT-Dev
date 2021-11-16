<?php

$cfg['RetainQueryBox'] = true;
$cfg['RowActionLinksWithoutUnique'] = true;
$cfg['Console']['Mode'] = 'collapse';
$cfg['DefaultTransformations']['Substring'] = array (
  0 => '0',
  1 => 'all',
  2 => '…',
);
$cfg['DefaultTransformations']['External'] = array (
  0 => '0',
  1 => '-f /dev/null -i -wrap -q',
  2 => '1',
  3 => '1',
);
$cfg['DefaultTransformations']['DateFormat'] = array (
  0 => '0',
  1 => 'local',
);
$cfg['DefaultTransformations']['Inline'] = array (
  0 => '100',
  1 => '100',
);
$cfg['DefaultTransformations']['TextImageLink'] = array (
  0 => '100',
  1 => '50',
);
$cfg['MaxRows'] = 250;
$cfg['Server']['hide_db'] = '';
$cfg['Server']['only_db'] = '';
$cfg['2fa'] = array (
  'type' => 'db',
  'backend' => '',
  'settings' => 
  array (
  ),
);
$cfg['lang'] = 'fr';
