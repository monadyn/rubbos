'''
Created on Jul 7, 2011

@author: qingyang
'''
import dataPreparation
import csv
import sys

RUBBOS_RESULTS_DIR_CONFIG_FILE = ''

def main():
    # process options
    if len(sys.argv) == 2:
        RUBBOS_RESULTS_DIR_CONFIG_FILE = sys.argv[1]
    else: 
        # Windows environment
        RUBBOS_RESULTS_DIR_CONFIG_FILE = 'D:\workspace\SysVizResultAnalysis\data/ana3/set_elba_env.sh'
        #sys.exit(1)
    

    rubbosAnalyzer = dataPreparation.analyzer('D:\workspace\SysVizResultAnalysis\data\ana3')
    
    output_dir = 'D:\workspace\SysVizResultAnalysis\data/ana3'  
    filepath = 'D:\workspace\SysVizResultAnalysis\data/ana3' 
    fileList = ["wl3400"]
    MultiMetricsList = ["total:HTTP", "total:AJP", "total:DBmsg", "total:DBmsg_over10ms","total:DBmsg_over100ms","total:DBmsg_over1s", 
                        "1:HTTP", "1:AJP", "1:DBmsg", "1:DBmsg_over10ms","1:DBmsg_over100ms","1:DBmsg_over1s",
                        "4:HTTP", "4:AJP", "4:DBmsg", "4:DBmsg_over10ms","4:DBmsg_over100ms","4:DBmsg_over1s",
                        "11:HTTP", "11:AJP", "11:DBmsg", "11:DBmsg_over10ms","11:DBmsg_over100ms","11:DBmsg_over1s"
                        ]
    
#    MultiMetricsList = ["total:HTTP", "total:AJP", "total:DBmsg", "total:DBmsg_over10ms","total:DBmsg_over100ms","total:DBmsg_over1s", 
#                        "1:HTTP", "1:AJP", "1:DBmsg", "1:DBmsg_over10ms","1:DBmsg_over100ms","1:DBmsg_over1s",
#                        "4:HTTP", "4:AJP", "4:DBmsg", "4:DBmsg_over10ms","4:DBmsg_over100ms","4:DBmsg_over1s",
#                        "11:HTTP", "11:AJP", "11:DBmsg", "11:DBmsg_over10ms","11:DBmsg_over100ms","11:DBmsg_over1s",                     
#                        ]
    
#    MultiMetricsList = ["total:HTTP", "total:AJP", "total:DBmsg", "total:DBmsg_over10ms","total:DBmsg_over100ms","total:DBmsg_over1s", 
#                        "1:HTTP", "1:AJP", "1:DBmsg", "1:DBmsg_over10ms","1:DBmsg_over100ms","1:DBmsg_over1s",
#                        "4:HTTP", "4:AJP", "4:DBmsg", "4:DBmsg_over10ms","4:DBmsg_over100ms","4:DBmsg_over1s",
#                        "11:HTTP", "11:AJP", "11:DBmsg", "11:DBmsg_over10ms","11:DBmsg_over100ms","11:DBmsg_over1s",                     
#                        ]
    
    InOutPutMetricsList = ["total:DBmsg_start", "total:DBmsg_start_over10ms", "total:DBmsg_start_over100ms","total:DBmsg_start_over1s","total:DBmsg_end","total:DBmsg_end_over10ms", "total:DBmsg_end_over100ms", "total:DBmsg_end_over1s"]
#    RSMetricsList = ["total:HTTP_start_aveRS", "total:AJP_start_aveRS", "total:DBmsg_start_aveRS", "total:DBmsg_end_aveRS", 
#                     "1:HTTP_start_aveRS", "1:AJP_start_aveRS", "1:DBmsg_start_aveRS", "1:DBmsg_end_aveRS", 
#                     "4:HTTP_start_aveRS", "4:AJP_start_aveRS", "4:DBmsg_start_aveRS", "4:DBmsg_end_aveRS", 
#                     "11:HTTP_start_aveRS", "11:AJP_start_aveRS", "11:DBmsg_start_aveRS", "11:DBmsg_end_aveRS"
#                     ] 
    
    RSMetricsList = ["total:DBmsg_start_aveRS", "total:DBmsg_start_over10ms", "total:DBmsg_start_over100ms", "total:DBmsg_start_over1s", 
                     "1:DBmsg_start_aveRS", "1:DBmsg_start_over10ms", "1:DBmsg_start_over100ms", "1:DBmsg_start_over1s", 
                     "4:DBmsg_start_aveRS", "4:DBmsg_start_over10ms", "4:DBmsg_start_over100ms", "4:DBmsg_start_over1s", 
                     "11:DBmsg_start_aveRS", "11:DBmsg_start_over10ms", "11:DBmsg_start_over100ms", "11:DBmsg_start_over1s"
                     ] 
    
#    RSMetricsList = ["total:AJP_start_aveRS", "total:AJP_start_over10ms", "total:AJP_start_over100ms", "total:AJP_start_over1s", 
#                     "1:AJP_start_aveRS", "1:AJP_start_over10ms", "1:AJP_start_over100ms", "1:AJP_start_over1s", 
#                     "4:AJP_start_aveRS", "4:AJP_start_over10ms", "4:AJP_start_over100ms", "4:AJP_start_over1s", 
#                     "11:AJP_start_aveRS", "11:AJP_start_over10ms", "11:AJP_start_over100ms", "11:AJP_start_over1s"
#                     ] 

    epochTime = True
    
    
    
    InOutPutMetricsList = ["total:DBmsg_start", "total:DBmsg_start_over10ms", "total:DBmsg_start_over100ms","total:DBmsg_start_over1s","total:DBmsg_end","total:DBmsg_end_over10ms", "total:DBmsg_end_over100ms","total:DBmsg_end_over1s",
                           "1:DBmsg_start", "1:DBmsg_start_over10ms", "1:DBmsg_start_over100ms", "1:DBmsg_start_over1s",
                           "4:DBmsg_start", "4:DBmsg_start_over10ms", "4:DBmsg_start_over100ms", "4:DBmsg_start_over1s",
                           "11:DBmsg_start", "11:DBmsg_start_over10ms", "11:DBmsg_start_over100ms", "11:DBmsg_start_over1s"]
#    InOutPutMetricsList = ["total:AJP_start", "total:AJP_start_over10ms", "total:AJP_start_over100ms","total:AJP_start_over1s",
#                           "1:AJP_start", "1:AJP_start_over10ms", "1:AJP_start_over100ms", "1:AJP_start_over1s",
#                           "4:AJP_start", "4:AJP_start_over10ms", "4:AJP_start_over100ms", "4:AJP_start_over1s",
#                           "11:AJP_start", "11:AJP_start_over10ms", "11:AJP_start_over100ms", "11:AJP_start_over1s"]
    
    rubbosAnalyzer.generateCustmizedMultiplicity(filepath, output_dir, fileList, MultiMetricsList, epochTime)
    #rubbosAnalyzer.generateCustmizedResponsetime(filepath, output_dir, fileList, RSMetricsList, epochTime)
    rubbosAnalyzer.generateCustmizedInOutput(filepath, output_dir, fileList, InOutPutMetricsList, epochTime)
    
    MultiMetricsList = ["total:DBmsg"]
    CPUMetricsList = ["[CPU]Totl%", "[CPU]User%", "[CPU]Sys%", "[CPU]Wait%"]  
    #rubbosAnalyzer.generateCustmizedFineGrainedMonitor(filepath, output_dir, fileList, CPUMetricsList, MultiMetricsList, epochTime)
    
    rubbosAnalyzer.generateSaturationDurationAna(filepath, output_dir, fileList, MultiMetricsList, epochTime)

#
#    H = {}
#    for row in csv.reader(open(RUBBOS_RESULTS_DIR_CONFIG_FILE, "r"), delimiter="=" ):
#        if len(row) == 2:
#            H[row[0]] = row[1]
#            
#    bonnServer_out_dir = H["BONN_RUBBOS_RESULTS_DIR_BASE"]
#    sysVizServer_output_dir = H["SYSVIZ_RUBBOS_RESULTS_DIR_BASE"]
#    rubbosData_output_dir = H["RUBBOS_RESULTS_DIR_NAME"]
#    
##    bonnServer_out_dir = '/mnt/sdc/qywang/rubbosResult/2011-06-28T103236-0400-QYW-121-oneCore-DBconn12'
##    sysVizServer_output_dir = '/home/qywang/AnaResult'
#    tiers = int(H["EXPERIMENT_CONFIG_TIERS"])
#     
#    if tiers ==3:
#        importModule = "analyzer6_linux_middleTwoTier" 
#        rubbosAnalyzer.generateSysVizProcessingScripts(bonnServer_out_dir, sysVizServer_output_dir, rubbosData_output_dir, tiers, importModule)
#    elif tiers == 4:
#        importModule = "analyzer6_linux_4tier_middleTwoTier" 
#        rubbosAnalyzer.generateSysVizProcessingScripts(bonnServer_out_dir, sysVizServer_output_dir, rubbosData_output_dir, tiers, importModule)
      
if __name__ == '__main__':
    main()
    

