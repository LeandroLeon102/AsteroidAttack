wave_points = 2.4
for i in range(25):
    total_wave_points = (i+1)*wave_points
    print(['wave '+str(i+1),
           "{:.2f}".format(total_wave_points),
           total_wave_points // 2.4,
           total_wave_points // 4,
           total_wave_points // 6,
           total_wave_points // 10,
           total_wave_points //6 //3,])
