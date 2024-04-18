#!/bin/bash
echo "<h3>Instance id:$(curl http://169.254.169.254/latest/meta-data/instance-id)</h3>" >>index.html