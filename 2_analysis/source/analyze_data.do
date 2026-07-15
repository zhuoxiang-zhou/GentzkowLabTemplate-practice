* =============================================================================
* Short description of script's purpose
* =============================================================================

clear all
adopath + "../../lib/stata"
set linesize 100
set scheme stcolor

* =============================================================================

program main
    use "../input/mpg.dta", clear
    regression_table
	city_figure
	hwy_figure
end

program regression_table
    reg displ cty, vce(cluster year)
    estimates store cty_clustered
    
    reg displ hwy, vce(cluster year)
    estimates store hwy_clustered
    
    reg displ hwy cty, vce(cluster year)
    estimates store hwy_cty_clustered
    
    esttab hwy_clustered cty_clustered hwy_cty_clustered ///
        using ../output/table_reg_clustered.tex, ///
        cells(b se p) ///
        replace
end

program city_figure
	tempvar log_cty
	gen `log_cty' = log(cty)

    scatter `log_cty' displ, xtitle("Engine displacement (L)") ///
		ytitle("Log city fuel economy (mpg)") ///
		mcolor(year)
	graph export ../output/figure_city.jpg, replace
end

program hwy_figure
    tempvar log_hwy
    gen `log_hwy' = log(hwy)

    scatter `log_hwy' displ, xtitle("Engine displacement (L)") ///
        ytitle("Log highway fuel economy (mpg)") ///
        mcolor(year)
    graph export ../output/figure_hwy.jpg, replace
end
* Execute
main
