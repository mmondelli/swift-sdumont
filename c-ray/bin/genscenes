step=$1
steps=$2
z=-2.0

templ=$3
sed -e "s/\@/$z/" $templ > scene.0.data

incr=$(echo "scale=4; 4.0/$steps" | bc)
z=$(echo "scale=4; $z+$incr*$step" | bc)
sed -e "s/\@/$z/" $templ
