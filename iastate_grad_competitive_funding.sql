-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: competitivefunding
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `awardtype`
--

DROP TABLE IF EXISTS `awardtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `awardtype` (
  `name` varchar(255) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `awardtype`
--

LOCK TABLES `awardtype` WRITE;
/*!40000 ALTER TABLE `awardtype` DISABLE KEYS */;
INSERT INTO `awardtype` VALUES ('Scholarship',1),('Fellowship',2),('Grant',3),('Travel',4),('Conference',5),('Dissertation',6),('Artist/Writer Residency',10),('Postdoctoral Fellowship',11),('Award',12);
/*!40000 ALTER TABLE `awardtype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `awardtypeopportunity`
--

DROP TABLE IF EXISTS `awardtypeopportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `awardtypeopportunity` (
  `awardtype_id` int NOT NULL,
  `opportunity_id` int NOT NULL,
  PRIMARY KEY (`awardtype_id`,`opportunity_id`),
  KEY `fk_awardtype_opportunity` (`awardtype_id`),
  KEY `fk_opportunity_awardtype` (`opportunity_id`),
  CONSTRAINT `fk_awardtype_opportunity` FOREIGN KEY (`awardtype_id`) REFERENCES `awardtype` (`id`),
  CONSTRAINT `fk_opportunity_awardtype` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `awardtypeopportunity`
--

LOCK TABLES `awardtypeopportunity` WRITE;
/*!40000 ALTER TABLE `awardtypeopportunity` DISABLE KEYS */;
INSERT INTO `awardtypeopportunity` VALUES (2,1),(4,1),(4,10),(5,10),(2,11),(2,7),(2,8),(1,13),(12,14),(2,6),(12,16),(12,15),(12,17),(12,18),(3,19),(12,20),(1,20),(12,21),(1,21),(4,21),(12,22),(5,22),(3,22),(1,22),(4,22),(5,23),(3,23),(4,23),(5,24),(2,24),(3,24),(4,24),(2,25),(3,25),(4,25),(2,26),(3,26),(12,27),(5,27),(4,27),(12,28),(2,28),(3,28),(4,28),(1,29),(2,30),(1,30),(2,31),(3,31),(1,31),(4,31),(2,32),(3,32),(4,32),(5,33),(6,33),(2,33),(3,33);
/*!40000 ALTER TABLE `awardtypeopportunity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cycle`
--

DROP TABLE IF EXISTS `cycle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cycle` (
  `name` varchar(255) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cycle`
--

LOCK TABLES `cycle` WRITE;
/*!40000 ALTER TABLE `cycle` DISABLE KEYS */;
/*!40000 ALTER TABLE `cycle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cycleopportunity`
--

DROP TABLE IF EXISTS `cycleopportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cycleopportunity` (
  `cycle_id` int NOT NULL,
  `opportunity_id` int NOT NULL,
  PRIMARY KEY (`cycle_id`,`opportunity_id`),
  KEY `fk_cycle_opportunity` (`cycle_id`),
  KEY `fk_opportunity_cycle` (`opportunity_id`),
  CONSTRAINT `fk_cycle_opportunity` FOREIGN KEY (`cycle_id`) REFERENCES `cycle` (`id`),
  CONSTRAINT `fk_opportunity_cycle` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cycleopportunity`
--

LOCK TABLES `cycleopportunity` WRITE;
/*!40000 ALTER TABLE `cycleopportunity` DISABLE KEYS */;
/*!40000 ALTER TABLE `cycleopportunity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `degree`
--

DROP TABLE IF EXISTS `degree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `degree` (
  `name` varchar(255) NOT NULL,
  `abbreviation` varchar(10) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `degree`
--

LOCK TABLES `degree` WRITE;
/*!40000 ALTER TABLE `degree` DISABLE KEYS */;
/*!40000 ALTER TABLE `degree` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `degreeprogram`
--

DROP TABLE IF EXISTS `degreeprogram`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `degreeprogram` (
  `degree_id` int NOT NULL,
  `program_id` int NOT NULL,
  PRIMARY KEY (`degree_id`,`program_id`),
  UNIQUE KEY `degree_id` (`degree_id`,`program_id`),
  KEY `fk_program_deg` (`program_id`),
  CONSTRAINT `fk_degree_prog` FOREIGN KEY (`degree_id`) REFERENCES `degree` (`id`),
  CONSTRAINT `fk_program_deg` FOREIGN KEY (`program_id`) REFERENCES `program` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `degreeprogram`
--

LOCK TABLES `degreeprogram` WRITE;
/*!40000 ALTER TABLE `degreeprogram` DISABLE KEYS */;
/*!40000 ALTER TABLE `degreeprogram` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `name` varchar(255) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=915 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES ('Agricultural and Biosystems Engineering',852),('Agronomy',853),('Ecology, Evolution and Organismal Biology',854),('Food Science and Human Nutrition',855),('Horticulture',856),('Plant Pathology, Entomology and Microbiology',857),('Sociology and Criminal Justice',858),('Agricultural Education and Studies',859),('Animal Science',860),('Economics',861),('Genetics, Development and Cell Biology',862),('Natural Resource Ecology and Management',863),('Roy J Carver Department of Biochemistry, Biophysics and Molecular Biology',864),('Statistics',865),('Ivy College of Business',866),('Architecture',867),('Art and Visual Culture',868),('Community and Regional Planning',869),('Graphic Design',870),('Industrial Design',871),('Interior Design',872),('Landscape Architecture',873),('Sustainable Environments',874),('Urban Design',875),('Aerospace Engineering',876),('Chemical and Biological Engineering',877),('Civil, Construction and Environmental Engineering',878),('Electrical and Computer Engineering',879),('Industrial and Manufacturing Systems Engineering',880),('Materials Science and Engineering',881),('Mechanical Engineering',882),('Apparel, Events, and Hospitality Management',883),('Human Development and Family Studies',884),('Kinesiology',885),('School of Education',886),('Biomedical Sciences',887),('Veterinary Clinical Sciences',888),('Veterinary Diagnostic and Production Animal Medicine',889),('Veterinary Microbiology and Preventive Medicine',890),('Veterinary Pathology',891),('Air Force Aerospace Studies',892),('Chemistry',893),('Computer Science',894),('English',895),('Geological and Atmospheric Sciences',896),('Greenlee School of Journalism and Communication',897),('History',898),('Mathematics',899),('Military Science',900),('Music and Theatre',901),('Naval Science',902),('Philosophy and Religious Studies',903),('Political Science',904),('Psychology',905),('World Languages and Cultures',906),('Physics and Astronomy',907),('Engineering Online',908),('Center for Excellence in Learning and Teaching',909),('College of Agriculture and Life Sciences Online Learning',910),('College of Human Sciences Online Learning',911),('Department of the Earth, Atmosphere, and Climate',913);
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `field`
--

DROP TABLE IF EXISTS `field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `field` (
  `name` varchar(255) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `field`
--

LOCK TABLES `field` WRITE;
/*!40000 ALTER TABLE `field` DISABLE KEYS */;
INSERT INTO `field` VALUES ('Humanities',1),('Social Science',2),('STEM (Science, Technology, Engineering, & Mathematics)',3),('Fine Arts',4),('Veterinary',5),('Business',6);
/*!40000 ALTER TABLE `field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fieldopportunity`
--

DROP TABLE IF EXISTS `fieldopportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fieldopportunity` (
  `field_id` int NOT NULL,
  `opportunity_id` int NOT NULL,
  PRIMARY KEY (`field_id`,`opportunity_id`),
  KEY `fk_field_opportunity` (`field_id`),
  KEY `fk_opportunity_field` (`opportunity_id`),
  CONSTRAINT `fk_field_opportunity` FOREIGN KEY (`field_id`) REFERENCES `field` (`id`),
  CONSTRAINT `fk_opportunity_field` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fieldopportunity`
--

LOCK TABLES `fieldopportunity` WRITE;
/*!40000 ALTER TABLE `fieldopportunity` DISABLE KEYS */;
INSERT INTO `fieldopportunity` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(1,10),(2,10),(3,10),(4,10),(5,10),(6,10),(1,11),(3,7),(2,8),(3,8),(1,13),(2,13),(3,13),(4,13),(5,13),(6,13),(1,14),(2,14),(3,14),(3,6),(1,16),(2,16),(3,16),(4,16),(5,16),(6,16),(1,15),(2,15),(3,15),(4,15),(5,15),(6,15),(1,17),(2,17),(3,17),(4,17),(5,17),(6,17),(1,18),(2,18),(3,18),(4,18),(5,18),(6,18),(3,19),(3,20),(3,21),(3,22),(3,23),(3,24),(3,25),(3,26),(3,27),(3,28),(6,29),(3,29),(3,30),(1,31),(3,31),(1,32),(2,32),(3,33);
/*!40000 ALTER TABLE `fieldopportunity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nationality`
--

DROP TABLE IF EXISTS `nationality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nationality` (
  `name` varchar(255) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nationality`
--

LOCK TABLES `nationality` WRITE;
/*!40000 ALTER TABLE `nationality` DISABLE KEYS */;
INSERT INTO `nationality` VALUES ('U.S. citizen, national, or permanent resident',1),('International',2);
/*!40000 ALTER TABLE `nationality` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nationalityopportunity`
--

DROP TABLE IF EXISTS `nationalityopportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nationalityopportunity` (
  `nationality_id` int NOT NULL,
  `opportunity_id` int NOT NULL,
  PRIMARY KEY (`nationality_id`,`opportunity_id`),
  KEY `fk_nationality_opportunity` (`nationality_id`),
  KEY `fk_opportunity_nationality` (`opportunity_id`),
  CONSTRAINT `fk_nationality_opportunity` FOREIGN KEY (`nationality_id`) REFERENCES `nationality` (`id`),
  CONSTRAINT `fk_opportunity_nationality` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nationalityopportunity`
--

LOCK TABLES `nationalityopportunity` WRITE;
/*!40000 ALTER TABLE `nationalityopportunity` DISABLE KEYS */;
INSERT INTO `nationalityopportunity` VALUES (1,1),(2,10),(1,11),(2,11),(1,7),(1,8),(2,8),(1,13),(2,13),(1,14),(2,14),(1,6),(1,16),(2,16),(1,15),(2,15),(1,17),(2,17),(1,18),(2,18),(1,19),(2,19),(1,20),(2,20),(1,21),(2,21),(1,22),(2,22),(1,23),(2,23),(1,24),(2,24),(1,25),(2,25),(1,26),(2,26),(1,27),(2,27),(1,28),(2,28),(1,29),(2,29),(1,30),(2,30),(1,31),(2,31),(1,32),(2,32),(1,33),(2,33);
/*!40000 ALTER TABLE `nationalityopportunity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opportunity`
--

DROP TABLE IF EXISTS `opportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opportunity` (
  `name` varchar(255) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `website` varchar(2048) DEFAULT NULL,
  `description` mediumtext,
  `organization_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_opportunity_org` (`organization_id`),
  FULLTEXT KEY `full_text_name` (`name`),
  FULLTEXT KEY `full_text_description` (`description`),
  CONSTRAINT `fk_opportunity_org` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opportunity`
--

LOCK TABLES `opportunity` WRITE;
/*!40000 ALTER TABLE `opportunity` DISABLE KEYS */;
INSERT INTO `opportunity` VALUES ('Fulbright U.S. Student Program',1,'https://us.fulbrightonline.org/','The Fulbright U.S. Student Program expands perspectives through academic and professional advancement and cross-cultural dialogue. Fulbright finds solutions to complex global issues and creates connections in a changing world. In partnership with more than 140 countries worldwide, the Fulbright U.S. Student Program offers unparalleled opportunities to advance knowledge and innovation across all academic disciplines. Awards are available to passionate and accomplished graduating college seniors, graduate students, and young professionals from all backgrounds. Program participants pursue graduate study, conduct research, or teach English abroad.\n    \n        \n        ',1),('Graduate Research Fellowship Program',6,'https://www.nsfgrfp.org/','The purpose of the NSF Graduate Research Fellowship Program (GRFP) is to help ensure the quality, vitality, and strength of the scientific and engineering workforce of the United States. Since 1952, the program recognizes and supports outstanding graduate students who are pursuing full-time research-based master\'s and doctoral degrees in science, technology, engineering, and mathematics (STEM) fields, including STEM education. NSF GRFP was established to recruit and support individuals who demonstrate the potential to make significant contributions in STEM, including STEM education. NSF encourages applications from the full spectrum of talent that the U.S. has to offer.    ',2),('The GEM Fellowship Program',7,'https://www.gemfellowship.org/gem-fellowship-program/','GEM offers MS and Ph.D. level students an outstanding opportunity and access to dozens of the top Engineering and Science firms and Universities in the nation. The GEM Fellowship was designed to focus on promoting opportunities for individuals to enter industry at the graduate level in areas such as research and development, product development, and other high level technical careers. GEM also offers exposure to a number of opportunities in academia.    \n        ',5),('AWWA Abel Wolman Fellowship',8,'https://www.awwa.org/water-equation/awwa-scholarship-program/','Established in 1984, this Fellowship is named after Dr. Abel Wolman. The endowment was established to assist highly qualified students who continue meaningful research in water supply through doctoral programs. This award of excellence recognizes those whose careers in the water sector exemplify the vision, creativity, and excellent professional performance characteristic of Wolman’s long and productive career. The applicant’s work must exemplify vision, creativity, and excellence, and must have had a recognizable impact on the professionalism of the industry.\n\nThe Abel Wolman Fellowship supports promising students in the U.S., Canada, and Mexico who are pursuing advanced training and research in the field of water supply and treatment. To accomplish this objective, a doctoral fellowship provides up to two years of support, awarded annually to the most outstanding student. The initial award for one year is $30,000, with a second year of support available.    ',6),('Schuh Fulbright Enrichment Award',10,'https://iastate.app.box.com/s/7e4ev36fojwgrlkqjrlhd2qqgrs8uzku/file/2321007078723',' The Schuh Fulbright Enrichment Fund provides funding to international Fulbright students and scholars to\nenhance their experience at Iowa State through their participation in cultural enrichment within the state of\nIowa or in the Midwest region.\n• This award nomination is for foreign Fulbright students and scholars at Iowa State to participate in local and\nMidwestern cultural enrichment, either as individuals or as a sponsored group (specific eligibility criteria is\nlisted below).\n• Individuals can be awarded a maximum of $500 per trip\n• Approved student groups can be awarded a maximum of $1500 per trip\n• Maximum of two (2) funded trips will be awarded per person per fiscal year (this maximum includes\nattendance across both individual and group trips)\n• Award selection will run three times during the academic year.        ',7),('Reference Guides to Rhetoric and Composition - The Susan H. McLeod New Scholar Fellowship',11,'https://wacclearinghouse.org/about/positions/fellows2026-27','        The Reference Guide Series’ volumes provide comprehensive overviews (historical, theoretical, empirical, pedagogical) of topics in rhetoric and composition, with the goal of serving as resources for research and teaching. Based on recent survey feedback on how the series is being utilized and its potential for future use, this project’s goals are to improve the series’ impact (via increased proposals) and to create space for diverse scholarship and authors, opportunities for author collaboration or networking, and materials that will be more accessible and inviting to new scholars.\n\nThis 12-month fellowship has a stipend of $1,000. The fellow will gain professional and editorial experience by\n\nSynthesizing survey data from readers (131 respondents across 8 listservs) and creating an implementation plan based on respondents’ feedback on the series;\nWorking with the editorial team to redesign the webpage, promotional materials (helping decide what marketing materials/venues are most useful/timely), and author submission guidelines, including updating accessibility guidelines and practices and creating more inclusive language;\nWorking with the editorial team to create resources for authors (such as sample proposals) and support services (mentoring) for potential new authors;\nWorking with the editorial team to identify contemporary topic areas for expanding Reference Guides (e.g., AI and writing, writing centers, critical language awareness, disability studies, anti-racist pedagogy);\nWorking with the editorial team to make visible the scholarly impact of the Reference Guides Series (e.g., adding citation data and downloading statistics).\nThe deliverables for the fellowship will include:\n\nA final report documenting an action plan based on survey results and early outcomes; the report will also contain a sustainability plan;\nAn improved webpage with revised author guidelines and transparent scholarly impact data for current and prospective authors;\nNew marketing materials and author resources; and\nUpdated accessibility guidelines and practices.\nThe Fellow will meet regularly with the editorial team to discuss ideas, review progress, and implement plans, beginning with an onboarding meeting with the full editorial team to establish goals, review the survey report together, and agree on priorities. The editors will meet monthly (via Zoom) with the fellow, review all drafts in progress, and correspond electronically and collaborate/comment on work in progress via Google Docs.',8),('Laura Bassi Scholarship',13,'https://editing.press/bassi','The Laura Bassi Scholarship was established in 2018 with the aim of providing editorial assistance to postgraduates and junior academics whose research focuses on neglected topics of study, broadly construed, within their disciplines. The scholarships are open to every discipline and are awarded three times per year: December, April, and August. The value of the scholarship is remitted solely through editorial assistance as follows:\r\n\r\nMaster’s candidates: $750\r\nDoctoral candidates: $2,500\r\nJunior academics: $500\r\n\r\nThese figures reflect the upper bracket of costs of editorial assistance for master’s theses, doctoral dissertations, and academic journal articles, respectively. All currently enrolled master’s and doctoral candidates are eligible to apply, as are academics in the first five years of full-time employment. There are no institutional, departmental, or national restrictions.        ',11),('MAGS/ProQuest Distinguished Master\'s Thesis Awards',14,'https://mags-net.org/distinguished-thesis-award/','The purpose of the annual MAGS/ProQuest Distinguished Master’s Thesis Awards is to recognize and reward distinguished scholarship and research at the master’s level.  The categories alternate each year:\r\n\r\nOdd years: Disciplines of Social Sciences; and, Mathematics, Physical Sciences, and Engineering\r\nEven years: Disciplines of Biological and Life Sciences; and, Humanities        ',12),('Karas Award',15,'https://www.grad-college.iastate.edu/student/awards/karas-award','The Karas Award for Outstanding Dissertation has been established to recognize excellence in doctoral research at Iowa State University. Each year the two winners of this award become Iowa State University’s nominees to the national competition for the Council of Graduate Schools (CGS)/University Microfilms International (UMI) Distinguished Dissertation Award. Awards are selected annually in two of the rotating four broad disciplinary areas announced by the Council of Graduate Schools—Humanities and the Fine Arts, Mathematical and Physical Sciences and Engineering, Biological Sciences, and Social Sciences. (The CGS/UMI Distinguished Dissertation Award, consisting of an honorarium of $2,000 and a certificate of citation, is presented at the annual meeting of the Council of Graduate School in early December each year.)        ',7),('Zaffarano Prize Award',16,'https://www.grad-college.iastate.edu/resources/awards#karas','The award is offered each spring semester: to recognize superior performance in publishable research by an ISU graduate student. Publishable research is defined as work written and accepted for publication in a national or international refereed journal. Both the quality and the number of publications produced while a student at ISU will be considered. Nominees must either be currently enrolled at ISU or have graduated in the 2 preceding terms.        ',7),('Teaching Excellence Award',17,'https://www.grad-college.iastate.edu/resources/awards/tex','The purpose of these awards is to recognize and encourage outstanding teaching achievement by graduate students. The intent is to recognize up to 10% of the graduate students involved in teaching each year. Departments can choose to be more restrictive in the number of awards they give out, according to their criteria and policies.        ',7),('Research Excellence Award',18,'https://www.grad-college.iastate.edu/resources/awards/rex','The purpose of these awards is to recognize graduate students for outstanding research accomplishments as documented in their theses and dissertations. These students are also expected to be academically superior and able not only to do research, but also to develop a well written product. The intent of this program is to recognize \"the best of the best\" graduating students who have submitted theses and dissertations.\r\n\r\n        \r\n        ',7),('Myron Zucker Student-Faculty Grant Program',19,'https://ias.ieee.org/member-development/myron-zucker-programs/','In general, the Program functions much like a research support agency. It is administered by the IEEE Industry Applications Society through its Zucker Grant Committee with the consent of the IEEE Foundation.\r\n\r\nThe project must be designed to produce publishable results in one year (12 months). The preferred period of performance (for these 12 months) is September 1st through August 31st of the following year. The funding is such that approximately two grants, not exceeding $25,000 each, can be awarded during each annual proposal cycle. This endowment is the programs only funding source; no other sources, including IEEE membership dues, are used.        ',13),('NPSS Graduate Scholarship Award',20,'https://ieee-npss.org/awards/npss-awards/','Description: To recognize contributions to the fields of Nuclear and Plasma Sciences.\r\n\r\nPrize: $2500, Certificate, and one-year paid membership in the NPSS.\r\n\r\nFunding: Funded by the IEEE Nuclear and Plasma Sciences Society.\r\n\r\nEligibility: Any graduate student in the fields of Nuclear and Plasma Sciences.\r\n\r\nBasis for Judging: Evidence of scholarship such as academic record, reports, presentations, publications, research plans, related projects and related work experience. Participation in IEEE activities through presentations, publications, student Chapter involvement, etc., will also be considered. Nominations limited to 8 pages in length.\r\n\r\nPresentation: Check and certificates sent to nominator to be presented at a special occasion at the winner’s institution.\r\n\r\nFrequency: Up to four (4) awards presented annually.\r\n\r\nNominations: SUBMIT BY JANUARY 31 each year to the Awards Chair.        ',13),('NPSS Robert J Barker Graduate Student Award for Excellence in Pulsed Power Applications',21,'https://ieee-npss.org/awards/npss-awards/','Description: To recognize and enable outstanding graduate students enrolled in an accredited MS or Ph.D. level research program in the field of nuclear and plasma sciences, in pulsed power applications with preference given to medical and environmental applications and to compact pulsed power research and applications.\r\n\r\nPrize: The recipient will receive US$3000, a travel allocation not to exceed US$500, and a plaque. Only One Allowable Recipient Selected Annually. Recipient receives full prize including honoraria, and, if applicable, plaque and/or certificate.\r\n\r\nFunding: Funded by an endowment through a gift from Karl and Gisela Schoenbach and Fran Barker, and funds provided by the IEEE Nuclear and Plasma Sciences Society, and managed by the IEEE Foundation.\r\n\r\nEligibility: Graduate students enrolled in an accredited MS or Ph.D. level research program in the field of nuclear and plasma sciences, in pulsed power applications with preference given to medical and environmental applications and to compact pulsed power research and applications. Nominees must be a student when nominated and be members in good standing of the IEEE NPSS.\r\n\r\nBasis for Judging: Judging will be based on outstanding contributions to nuclear and plasma sciences, with the preference given to areas within the broadest scope of plasma sciences encompassing medical and environmental pulsed power applications, compact pulsed power research and applications, and high power microwaves.\r\n\r\nQuality of research contributions (40 points);\r\nQuality of educational accomplishments (30 points);\r\nQuality and significance of publications and patents (30 points)..\r\nPresentation: At an IEEE NPS Society Conference specified by the recipient, preferably at the IEEE Pulsed Power Conference.        ',13),('IEEE Ronald J. Jaszczak Graduate Award',22,'https://ieee-npss.org/awards/npss-awards/','Description: Recognizes and enables an outstanding graduate student enrolled in an accredited Ph.D. curriculum, Post-doctoral Fellow or Ph.D. level Research Associate in the field of nuclear and medical imaging sciences to advance his/her research activities.\r\n\r\nPrize: The Graduate Award will be used to provide support for one (1) year to one (1) individual recipient for expenses as follows:\r\n\r\nUp to a maximum of U.S. $5,000 one (1) year to be used to support, for example, the following academic and/or research activities:\r\nattendance at appropriate scientific workshops;\r\nvisit appropriate colleague research laboratories;\r\ntravel to make presentations during the annual IEEE NPSS Medical Imaging Conference (MIC) or IEEE Nuclear Science Symposium (NSS);\r\nannual IEEE and NPSS membership fees;\r\npurchase of appropriate specialized research publications, software or hardware when traditional institutional or grant support is unavailable.\r\nFunding: By the IEEE Foundation though a gift from Ronald Jaszczak and the Nuclear and Plasma Sciences Society.\r\n\r\nEligibility: Award nominee must:\r\n\r\nBe 35 years of age or younger at the date that the application form is submitted\r\nBe a graduate student that has completed at least one year of graduate studies at a University and is working to obtain a Ph.D. degree, or be a Post-Doctoral Fellow or Ph.D. level Research Associate at a University or at a Non-profit Research Institute\r\nBe actively engaged in Engineering or Physics research related to the field of Nuclear and Medical Imaging Sciences\r\nThe applicant must be a regular or student member of IEEE NPSS, or have applied for NPSS membership, by the Deadline date for the receipt of the Nomination Package.\r\nConsideration will be given to nominees of Western Slavic heritage that use the Latin alphabet, for example, Polish-American, Czech-American, Croatian – American, Slovak-American, Slovenian-American.        ',13),('IEEE Glenn F. Knoll Post Doctoral Educational Grant',23,'https://ieee-npss.org/awards/npss-awards/','Description: For outstanding post doctoral researchers in the field of nuclear science instrumentation, medical instrumentation, or instrumentation for security applications. The grant is intended to support travel and attendance to conferences, workshops or summer schools, or special research projects.\r\n\r\nPrize:  $5000 and plaque. Multiple recipients are not allowed.\r\n\r\nFunding: By the IEEE Foundation through gifts from Gladys H. Knoll and Valentin T. Jordanov, and funds provided by the IEEE Nuclear and Plasma Sciences Society.\r\n\r\nEligibility: Any post doctoral researcher who is a member in good standing of the IEEE and NPSS and is within 10 years of having received their doctoral degree.\r\n\r\nBasis for Judging: Judging will be based on the accomplishments of the candidate in their field of study and will include number of publications, talks and presentations at conferences, other awards and recognitions, quality of research and potential for future accomplishment. Up to three letters of recommendation may also be submitted with the nomination that will be used in the selection process.\r\n\r\nPresentation:  At an IEEE NPSS conference mutually agreed upon by the recipient and NPSS.\r\n\r\nFrequency:  Annual.  However, if the Awards Committee determines that there is no suitable candidate in a given year, no grant will be given that year.\r\n\r\nNominations: SUBMIT BY JANUARY 31 OF EACH YEAR to the Chair of the NPSS Awards Committee.        ',13),('IEEE Glenn F. Knoll Graduate Educational Grant',24,'https://ieee-npss.org/awards/npss-awards/','Description: For outstanding graduate students in the field of nuclear science instrumentation, medical instrumentation, or instrumentation for security applications. The grant is intended to support travel and attendance to conferences, workshops or summer schools, or special research projects.\r\n\r\nPrize:  $5000 and plaque. Multiple recipients are not allowed.\r\n\r\nFunding: By the IEEE Foundation through gifts from Gladys H. Knoll and Valentin T. Jordanov, and funds provided by the IEEE Nuclear and Plasma Sciences Society.\r\n\r\nEligibility: Any graduate student who is a member in good standing of the IEEE and NPSS.\r\n\r\nBasis for Judging: Judging will be based on the accomplishments of the candidate in their field of study and will include number of publications, talks and presentations at conferences, other awards and recognitions, quality of research and potential for future accomplishment. Up to three letters of recommendation may also be submitted with the nomination that will be used in the selection process.\r\n\r\nPresentation:  At an IEEE NPSS conference mutually agreed upon by the recipient and NPSS.\r\n\r\nFrequency:  Annual.  However, if the Awards Committee determines that there is no suitable candidate in a given year, no grant will be given that year.        ',13),('IEEE PELS Graduate Studies Scholarship and Jan Abraham \"Braham\" Ferreira Scholarship',25,'https://www.ieee-pels.org/awards/graduate-studies-scholarship-and-jan-abraham-braham-ferreira-scholarship/','Up to seven Graduate Studies Scholarships are awarded annually to promote, recognize, and support eligible students within the Society’s fields of interest. The purpose is to support awardees toward a stay at a foreign university or research institution.\r\n\r\nOne of these scholarships is the IEEE PELS Jan Abraham “Braham” Ferreira Scholarship named in honor of the late Professor Jan Abraham “Braham” Ferreira, who was a past president of PELS. This scholarship is reserved for the highest-ranked winner from a traditionally underserved country or region in the spirit of providing opportunities to those less able to financially manage the expenses of foreign study.\r\n\r\nThese scholarships are also funded by the IEEE Foundation’s Future Workforce Fund.        ',13),('Joseph John Suozzi INTELEC(R) Fellowship Award in Power Electronics',26,'https://www.ieee-pels.org/awards/joseph-john-suozzi-intelec-fellowship-award-in-power-electronics/',' This fellowship is open to electrical engineering graduate students specializing in power electronics that apply to information and communication technology and related energy systems. Applicants must be an IEEE Graduate Student Members and a PELS member.\r\n\r\nCriteria: Applications are evaluated both on the technical merit and novelty of the study topic proposed for the project and based on the applicant’s performance as a student.        ',13),('PELS Ph.D. Thesis Talk (P3 Talk)',27,'https://www.ieee-pels.org/awards/pels-ph-d-thesis-talk-p3-talk/','The IEEE PELS Ph.D. Thesis Talk (P3 Talk) competition showcases Ph.D. projects to the power electronics community. The topic of the Ph.D. thesis should be one of the focus areas of PELS. Potential areas are included in the submission guidelines. Up to five presenters are selected each year.\r\n\r\nPrize:\r\nCertificate\r\nHonorarium (1,000 USD)\r\nPresentation published on the Society’s website\r\nReimbursement towards the recipient’s necessary conference registration, travel, and accommodation costs incurred to attend the award ceremony (up to USD 1,000)        ',13),('Graduate Studies Fellowship and John G. Kassakian Fellowship',28,'https://www.ieee-pels.org/awards/graduate-studies-fellowship-and-john-g-kassakian-fellowship/','Up to seven Graduate Studies Fellowships are awarded annually to promote, recognize, and support eligible students within the Society’s fields of interest. The purpose is to support awardees toward a stay at a foreign university or research institution.\r\n\r\nOne of these fellowships is the IEEE PELS John G. Kassakian Fellowship named in honor of John G. Kassakian, who was the second president of the Power Electronics Council and the founding president of PELS. This fellowship is reserved for the highest-ranked winner.\r\n\r\nThese fellowships are also funded by the IEEE Foundation’s Future Workforce Fund.        ',13),('Signal Processing Society Scholarship Program',29,'https://signalprocessingsociety.org/community-involvement/sps-scholarship-program','The IEEE Signal Processing Society (SPS) awards scholarships of up to a total of US$7,000 for up to three years of consecutive support to students who have expressed interest and commitment to pursuing signal processing education and real-world career experiences. By generating interest and awareness among students, employers will gain insight about the value of investing in signal processing students as potential employees and assets to their companies, organizations, and institutions.\r\n\r\nStudents and graduate students from all 10 IEEE Regions are encouraged to apply!        ',13),('IEEE Life Members Graduate Study Fellowship in Electrical Engineering',30,'https://life.ieee.org/awards-fellowships/fellowships/graduate-study-fellowship-in-electrical-engineering/','The IEEE Board of Directors established the IEEE Life Members Graduate Study Fellowship in Electrical Engineering in February 2000. The fellowship is awarded annually to a full-time (per the guidelines of the full-time program in which the student will be enrolled), first-year graduate student pursuing a Master’s degree program (or a doctoral degree program if it is the first graduate degree for the student) for work in the area of electrical engineering at an engineering school/program of recognized standing worldwide.\r\n\r\nThe award carries a stipend of US$10,000 per year. This fellowship can be renewed for a second year for the same degree, based on the recipient’s satisfactory progress in the graduate program.        ',13),('IEEE Life Members History Fellowship',31,'https://life.ieee.org/awards-fellowships/fellowships/history-fellowship/','The IEEE Fellowship in the History of Electrical and Computing Technology is administered by the IEEE History Committee and sponsored by the IEEE Life Members Committee. The applications will be judged by a subcommittee of the IEEE History Committee, consisting of electrical engineers and historians. The Fellowship supports either one year of full-time graduate work in the history of electrical science and technology at a college or university of recognized standing or up to one year of post-doctoral research. The award carries a stipend of US$25,000 plus a research budget of up to US$3,000.        ',13),('Pugh Young Scholar in Residence',32,'https://history.ieee.org/programs/fellowships-prizes/pugh-young-scholar-in-residence/','The Pugh Young Scholar in Residence seeks to provide research experience for graduate students in the history of electrical and computer technologies. It is intended for future historians and is not suitable for engineering students unless there is a strong history component to their studies.        ',13),('IEEE Dielectrics & Electrical Insultation Society Graduate Fellowships',33,'https://ieeedeis.org/professional-development/student-fellowships/','The graduate fellowship, established by the Dielectrics and Electrical Insulation Society (DEIS), is a prestigious grant and enables its winner to further explore a research topic in the areas of electrical insulation and dielectric phenomena. The fellowship aims at students pursuing their Ph.D. degree and is awarded for a one-year research topic aside (but close to) the larger research project of the applicant.        ',13);
/*!40000 ALTER TABLE `opportunity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organization`
--

DROP TABLE IF EXISTS `organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organization` (
  `name` varchar(255) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `logopath` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `full_text_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization`
--

LOCK TABLES `organization` WRITE;
/*!40000 ALTER TABLE `organization` DISABLE KEYS */;
INSERT INTO `organization` VALUES ('Fulbright',1,'uploads/organizationLogos/Fulbright_Globe_RGB_FullColor.png'),('National Science Foundation',2,'uploads/organizationLogos/NSF_Official_logo_RGB.png'),('The National GEM Consortium',5,'uploads/organizationLogos/gem-logo-color-01-1-1.png'),('American Water Works Association',6,'uploads/organizationLogos/awwa-150x150.png'),('Iowa State University Graduate College',7,'uploads/organizationLogos/ISU_GC_left_red_r.png'),('WAC Clearinghouse',8,'uploads/organizationLogos/Logo-WACClearinghouse.png'),('Editing Press',11,'uploads/organizationLogos/logotorquoise.png'),('Midwestern Association of Graduate Schools',12,'uploads/organizationLogos/mags-logo-1.png'),('IEEE',13,'uploads/organizationLogos/ieee-mb-blue.png');
/*!40000 ALTER TABLE `organization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program`
--

DROP TABLE IF EXISTS `program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program` (
  `name` varchar(255) NOT NULL,
  `interdepartmental` tinyint(1) DEFAULT '0',
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=174 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program`
--

LOCK TABLES `program` WRITE;
/*!40000 ALTER TABLE `program` DISABLE KEYS */;
INSERT INTO `program` VALUES ('Accounting',0,1),('Accounting Analytics',0,2),('Advanced Manufacturing',0,3),('Aerospace Engineering',0,4),('Agricultural and Biosystems Engineering',0,5),('Agricultural Economics',0,6),('Agricultural Education',0,7),('Agricultural Meteorology',0,8),('Agronomy',0,9),('Analytical Chemistry',0,10),('Animal Breeding and Genetics',0,11),('Animal Physiology',0,12),('Animal Science',0,13),('Anthropology',0,14),('Apparel, Merchandising, and Design',0,15),('Applied Linguistics and Technology',0,16),('Applied Mathematics',0,17),('Applied Physics',0,18),('Applied Research Methods in the Human Sciences',0,19),('Applied Scientific Computing',0,20),('Applied Statistics',0,21),('Architecture',0,22),('Artificial Intelligence',0,23),('Astrophysics',0,24),('Athletic Training',0,25),('Biochemistry',0,26),('Bioinformatics and Computational Biology',1,27),('Biomedical Sciences',0,28),('Biophysics',0,29),('Business Administration',0,30),('Business Analytics',0,31),('Business and Technology',0,32),('Chemical Engineering',0,33),('Chemistry',0,34),('Civil Engineering',0,35),('Community Development',0,36),('Computational Fluid Dynamics',0,37),('Computer Engineering',0,38),('Computer Networking',0,39),('Computer Science',0,40),('Condensed Matter Physics',0,41),('Construction Management',0,42),('Creative Writing and Environment',0,43),('Criminal Justice',0,44),('Crop Production and Physiology',0,45),('Cyber Security',1,46),('Data Driven Food, Energy, and Water Decision Making',0,47),('Developmental and Family Sciences Advanced Research Design and Methods',0,48),('Diet and Exercise',0,49),('Digital Health',0,50),('Digital Marketplace Analytics',0,51),('Early Childhood and Family Policy',0,52),('Earth Science',0,53),('Ecology and Evolutionary Biology',0,54),('Economics',0,55),('Education',0,56),('Education and Outreach in Agriculture and Natural Resources',0,57),('Education for Social Justice',0,58),('Electrical Engineering',0,59),('Embedded Systems',0,60),('Energy Systems Engineering',0,61),('Engineering Management',0,62),('Engineering Mechanics',0,63),('English',0,64),('Enterprise Cybersecurity Management',0,65),('Entomology',0,66),('Entrepreneurship',0,67),('Entrepreneurship and Innovation',0,68),('Environmental Engineering',0,69),('Environmental Science',1,70),('Environmental Systems',0,71),('Event Management',0,72),('Family and Consumer Sciences',0,73),('Family Financial Planning',0,74),('Family Well-Being in Diverse Society',0,75),('Finance',0,76),('Financial Technology',0,77),('Fisheries Biology',0,78),('Food Safety and Defense',0,79),('Food Science and Technology',0,80),('Forestry',0,81),('Genetics and Genomics',1,82),('Geographic Information Systems',0,83),('Geology',0,84),('Gerontology',1,85),('Graphic Design',0,86),('Healthcare Analytics and Operations',0,87),('High Energy Physics',0,88),('History',0,89),('Horticulture',0,90),('Hospitality Management',0,91),('Human Computer Interaction',1,92),('Human Development and Family Studies',0,93),('Immunobiology',1,94),('Industrial and Agricultural Technology',0,95),('Industrial Design',0,96),('Industrial Engineering',0,97),('Infant and Early Childhood Mental Health',0,98),('Information Systems',0,99),('Inorganic Chemistry',0,100),('Instructional Design',0,101),('Integrated Visual Arts',0,102),('Interdisciplinary Graduate Studies',1,103),('Interior Design',0,104),('Journalism and Mass Communication',0,105),('Kinesiology',0,106),('Landscape Architecture',0,107),('Lifespan Development',0,108),('Linguistics',0,109),('Literacy Coaching',0,110),('Materials Science and Engineering',0,111),('Mathematics',0,112),('Mathematics Education',0,113),('Meat Science',0,114),('Mechanical Engineering',0,115),('Meteorology',0,116),('Microbiology',1,117),('Molecular, Cellular and Developmental Biology',1,118),('Neuroscience',1,119),('Nondestructive Evaluation',0,120),('Nuclear Physics',0,121),('Nursing',0,122),('Nutritional Sciences',1,123),('Organic Chemistry',0,124),('Philosophy',0,125),('Physical Chemistry',0,126),('Physics',0,127),('Plant Biology',1,128),('Plant Breeding',0,129),('Plant Pathology',0,130),('Political Science',0,131),('Population Sciences in Animal Health',0,132),('Postsecondary Teaching',0,133),('Power Systems Engineering',0,134),('Preservation and Cultural Heritage',0,135),('Professional Practice in Dietetics',0,136),('Psychology',0,137),('Public Management and Policy',0,138),('Quantitative Psychology',0,139),('Real Estate Development',0,140),('Rhetoric and Professional Communication',0,141),('Rhetoric, Composition, and Professional Communication',0,142),('Rural Agricultural Technological and Environmental History',0,143),('Rural Sociology',0,144),('Science Education',0,145),('Secondary Education',0,146),('Seed Business Management',0,147),('Seed Science and Technology',0,148),('Seed Technology and Business',1,149),('Sociology',0,150),('Soil Science',0,151),('Spanish',0,152),('Special Education',0,153),('Speech Communication',0,154),('Statistics',0,155),('Supply Chain Management',0,156),('Sustainable Agriculture',1,157),('Sustainable Environments',1,158),('Systems Engineering',0,159),('Teaching English as a Second Language/Applied Linguistics',0,160),('Teaching English as a Second Language/Teaching English as a Foreign Language',0,161),('Toxicology',1,162),('Urban and Regional Planning',0,163),('Urban Design',1,164),('Veterinary Clinical Science',0,165),('Veterinary Microbiology',0,166),('Veterinary Pathology',0,167),('Veterinary Preventive Medicine',0,168),('Wildlife Ecology',0,169),('Wind Energy Science, Engineering, and Policy',1,170),('Women’s and Gender Studies',0,171),('Youth Development Specialist',0,172),('Youth Program Management and Evaluation',0,173);
/*!40000 ALTER TABLE `program` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stage`
--

DROP TABLE IF EXISTS `stage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stage` (
  `name` varchar(255) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stage`
--

LOCK TABLES `stage` WRITE;
/*!40000 ALTER TABLE `stage` DISABLE KEYS */;
INSERT INTO `stage` VALUES ('Certificate',1),('Master\'s',2),('Doctoral Student',3),('Doctoral Candidate',4),('Postdoc',5);
/*!40000 ALTER TABLE `stage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stageopportunity`
--

DROP TABLE IF EXISTS `stageopportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stageopportunity` (
  `stage_id` int NOT NULL,
  `opportunity_id` int NOT NULL,
  PRIMARY KEY (`stage_id`,`opportunity_id`),
  KEY `fk_stage_opportunity` (`stage_id`),
  KEY `fk_opportunity_stage` (`opportunity_id`),
  CONSTRAINT `fk_opportunity_stage` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity` (`id`),
  CONSTRAINT `fk_stage_opportunity` FOREIGN KEY (`stage_id`) REFERENCES `stage` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stageopportunity`
--

LOCK TABLES `stageopportunity` WRITE;
/*!40000 ALTER TABLE `stageopportunity` DISABLE KEYS */;
INSERT INTO `stageopportunity` VALUES (1,1),(2,1),(3,1),(4,1),(2,10),(3,10),(4,10),(5,10),(3,11),(4,11),(3,7),(3,8),(4,8),(2,13),(4,13),(2,14),(2,6),(3,6),(4,16),(4,15),(2,17),(3,17),(4,17),(2,18),(4,18),(2,19),(3,19),(4,19),(5,19),(1,20),(2,20),(3,20),(4,20),(2,21),(3,21),(4,21),(3,22),(4,22),(5,22),(5,23),(2,24),(3,24),(4,24),(2,25),(3,25),(4,25),(2,26),(3,26),(4,26),(4,27),(5,27),(2,28),(3,28),(4,28),(2,29),(3,29),(4,29),(2,30),(3,30),(3,31),(4,31),(5,31),(2,32),(3,32),(4,32),(5,32),(3,33),(4,33);
/*!40000 ALTER TABLE `stageopportunity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `name` varchar(255) NOT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-04 15:44:10
