
cd /proj/Infosphere/qingyang/optabs_rubbos/Qingyang_1_2_1_4MH_First_Dstat
source set_elba_env.sh

# Transfer all sub scripts to target hosts
echo "*** scp scripts *************************************************"
echo I love you
ssh  $BENCHMARK_HOST /tmp/BENCHMARK_configure.sh &
sleep 10;
ssh $CLIENT1_HOST /tmp/CLIENT1_configure.sh &
sleep 10;
ssh $CLIENT2_HOST /tmp/CLIENT2_configure.sh &
sleep 10;
ssh $CLIENT3_HOST /tmp/CLIENT3_configure.sh &
sleep 10;
ssh $CLIENT4_HOST /tmp/CLIENT4_configure.sh &


