#!/usr/bin/perl

use lib qw'app /home/pef/pef-front-psgi-dist/lib /home/pef/dbix-struct/lib';

use Demo::AppFrontConfig;
use PEF::Front::Preload;
use DBIx::Struct (
	connector_module => 'PEF::Front::Connector',
	error_class      => 'DBIx::Struct::Error::Hash'
);

DBIx::Struct::connect();

use PEF::Front::Route (
	'/'             => ['/index', 'R'],
	'/index(.*)'    => '/appIndex$1',
	'/article/(.*)' => '/appArticle/$1',
	'/add'          => '/appAddArticle'
);

PEF::Front::Route->to_app();
