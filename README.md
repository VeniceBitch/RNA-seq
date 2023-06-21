# RNA-seq
### 软硬件要求：
数据（RNA-seq reads，索引，基因注释）
HISAT2（2.0.1或更高版本）
StringTie（1.2.2或更高版本）
SAMTools（0.1.19或更高版本）
R（3.2.2或更高版本）
Linux或Mac OS X（10.7或更高版本）的64位系统
4GB或以上（最低）或8GB或以上（推荐）的RAM

### RNA-seq.sh

该文件用于安装所需的软件，下载参考基因组及注释文件，将reads映射到基因组并将SAM文件转换为BAM文件并将所有样本的SAM文件进行排序和转换为BAM文件。

#### 使用方法：

1.将用于差异表达分析的R脚本（analysis.R）放置在与bash脚本相同的目录中

2.确保您具有执行脚本的必要权限

3.打开终端并导航到包含脚本的目录

4.将该脚本设置成可执行：chmod +x RNA-seq.sh

5.运行脚本：./RNA-seq.sh

6.脚本将执行RNA-Seq分析流程，包括数据下载、处理和差异表达分析。

#### 输出：

脚本将生成各种输出文件和目录，包括：

每个样本的对齐和排序后的BAM文件
StringTie为每个样本组装的转录本
合并的转录本文件。
合并的转录本与参考注释之间的比较结果。
R脚本生成的差异表达分析结果。


### analysis.R

该文件使用ballgown包进行RNA-seq分析，输入RNA-seq数据经该程序统计分析后可以获得基因表达的可视化信息。

#### 使用方法：

0.使用以下命令安装所需要的 R 包：
install.packages("ballgown")
install.packages("RSkittleBrewer")
install.packages("genefilter")
install.packages("dplyr")
install.packages("devtools")

1.将输入数据‘geuvadis——phenodata.csv’和该文件放置于同一个文件夹

2.将工作目录设置为该文件夹

3.运行指令：source("analysis.R")

4.脚本将执行RNA-seq分析，并生成结果文件（chrX_transcript_results.csv和chrX_gene_results.csv），并生成基因表达的可视化结果。

#### 输出：
1.chrX_transcript_results.csv：每个转录本的统计分析结果。

2.chrX_gene_results.csv：基因的统计分析结果。

3.可视化结果：
（1）以FPKM值衡量的基因丰度在各样本中的分布（按性别着色）
（2）跨样本的单个转录本的表达差异（按性别区分）
（3）所有共享同一基因座的转录本的结构和表达水平
（4）男女之间在转录本和基因水平上的差异表达

### RNA-seq.dockerfile

该文件用于创建基于CentOS 7 的容器化流程，用于运行基因组分析。它安装了所需的软件包，下载了所需软件，并进行了基因组分析和可视化绘图。

#### 使用方法：

1.使用提供的Dockerfile构建Docker镜像。打开终端，导航到包含Dockerfile的目录，并运行以下命令：
docker build -t genomics-pipeline.
该命令将构建Docker镜像，并将其标记为genomics-pipeline。

2.使用以下命令运行容器：
docker run -it genomics-pipeline
这个命令将基于genomics-pipeline镜像启动一个容器，并在容器内部打开一个交互式Shell。

3.在容器内部通过运行以下命令来执行基因组分析流程：
bash RNA-seq.sh

4.获得输出文件




