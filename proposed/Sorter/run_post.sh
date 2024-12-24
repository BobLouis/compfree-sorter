
cd sim

# ncverilog -f post_sim.f
vcs -R ../src/testfixture.v ../syn/n32_N16/Sorter_syn_0n82.v -v ../../../tsmc090_neg.v +access+r +vcs+fsdbon +fsdb+mda +fsdbfile+Sorter_post.fsdb +define+SDF +define+P3

cd ..