# conventions taken from the new clean scheam of EnsEMBL
# use lower case and underscores
# internal ids are integers named tablename_id
# same name is given in foreign key relations

# conventions taken from the new clean scheam of EnsEMBL
# use lower case and underscores
# internal ids are integers named tablename_id
# same name is given in foreign key relations

#
# Table structure for table 'dnafrag'
#

CREATE TABLE dnafrag (
  dnafrag_id int(10) NOT NULL auto_increment,
  start int(11) DEFAULT '0' NOT NULL,
  end int(11) DEFAULT '0' NOT NULL,
  name varchar(40) DEFAULT '' NOT NULL,
  genome_db_id int(10) DEFAULT '0' NOT NULL,
  dnafrag_type enum('RawContig','Chromosome','VirtualContig'),
  PRIMARY KEY (dnafrag_id),
  KEY dnafrag_id (dnafrag_id,name),
  UNIQUE name (name,genome_db_id,dnafrag_type)
);

#
# Table structure for table 'dnafrag_region'
#

CREATE TABLE dnafrag_region (
  synteny_region_id int(10) DEFAULT '0' NOT NULL,
  dnafrag_id int(10) DEFAULT '0' NOT NULL,
  seq_start int(10) unsigned DEFAULT '0' NOT NULL,
  seq_end int(10) unsigned DEFAULT '0' NOT NULL,
  UNIQUE unique_synteny (synteny_region_id,dnafrag_id),
  UNIQUE unique_synteny_reversed (dnafrag_id,synteny_region_id)
);

#
# Table structure for table 'gene_relationship'
#

CREATE TABLE gene_relationship (
  gene_relationship_id int(10) NOT NULL auto_increment,
  relationship_stable_id varchar(40),
  relationship_type enum('homologous_pair','family','interpro'),
  description varchar(255),
  annotation_confidence_score double,
  PRIMARY KEY (gene_relationship_id)
);

#
# Table structure for table 'gene_relationship_member'
#

CREATE TABLE gene_relationship_member (
  gene_relationship_id int(10),
  genome_db_id int(10),
  member_stable_id varchar(40),
  chrom_start int(10),
  chrom_end int(10),
  chromosome varchar(10),
  KEY gene_relationship_id (gene_relationship_id),
  KEY member_stable_id (member_stable_id)
);

#
# Table structure for table 'genome_db'
#

CREATE TABLE genome_db (
  genome_db_id int(10) NOT NULL auto_increment,
  taxon_id int(10) DEFAULT '0' NOT NULL,
  name varchar(40) DEFAULT '' NOT NULL,
  locator varchar(255) DEFAULT '' NOT NULL,
  PRIMARY KEY (genome_db_id),
  UNIQUE name (name,locator)
);

#
# Table structure for table 'genomic_align_block'
#

CREATE TABLE genomic_align_block (
  consensus_dnafrag_id int(10) DEFAULT '0' NOT NULL,
  consensus_start int(10) DEFAULT '0' NOT NULL,
  consensus_end int(10) DEFAULT '0' NOT NULL,
  query_dnafrag_id int(10) DEFAULT '0' NOT NULL,
  query_start int(10) DEFAULT '0' NOT NULL,
  query_end int(10) DEFAULT '0' NOT NULL,
  query_strand tinyint(4) DEFAULT '0' NOT NULL,
  score double,
  perc_id int(10),
  cigar_line mediumtext,
  PRIMARY KEY (consensus_dnafrag_id,consensus_start,consensus_end,query_dnafrag_id),
  KEY query_dnafrag_id (query_dnafrag_id,query_start,query_end),
  KEY query_dnafrag_id_2 (query_dnafrag_id,query_end)
);

#
# Table structure for table 'genomic_align_genome'
#

CREATE TABLE genomic_align_genome (
  consensus_genome_db_id int(11) DEFAULT '0' NOT NULL,
  query_genome_db_id int(11) DEFAULT '0' NOT NULL
);

# method_link table specifies which kind of link can exist between species
# (dna/dna alignment, synteny regions, homologous gene pairs,...)

#
# Table structure for table 'method_link'
#

CREATE TABLE method_link (
  method_link_id int(10) NOT NULL auto_increment,
  method_link_type varchar(10) DEFAULT '' NOT NULL,
  PRIMARY KEY (method_link_id)
);


# method_link_species table specifying which species are part of a 
# method_link_id

#
# Table structure for table 'method_link_species'
#

CREATE TABLE method_link_species (
  method_link_id int(10),
  genome_db_id int(10),
  UNIQUE method_link_id (method_link_id,genome_db_id)
);

#
# We have now decided that Synteny is inherently pairwise
# these tables hold the pairwise information for the synteny
# regions. We reuse the dnafrag table as a link out for identifiers
# (eg, '2' on mouse).
#

#
# Table structure for table 'synteny_region'
#

CREATE TABLE synteny_region (
  synteny_region_id int(10) NOT NULL auto_increment,
  rel_orientation tinyint(1) DEFAULT '1' NOT NULL,
  PRIMARY KEY (synteny_region_id)
);

