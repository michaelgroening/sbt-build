#!/bin/bash

#
# a simple test for sbt (caches some popular libs for DigitalGenius)
#
# @see http://stackoverflow.com/a/12781664/714426
#
mkdir project

cat > project/plugins.sbt <<EOF
addSbtPlugin("com.eed3si9n" % "sbt-buildinfo" % "0.6.1")

addSbtPlugin("io.spray" % "sbt-revolver" % "0.8.0")

addSbtPlugin("com.typesafe.sbt" %% "sbt-native-packager" % "1.1.5")

addSbtPlugin("org.scoverage" % "sbt-scoverage" % "1.5.0")
EOF

cat << EOF | sbt
set name := "SbtTest"
set version := "1.0"
set scalaVersion := "$SCALA_VERSION"
set libraryDependencies += "com.typesafe" % "config" % "latest.integration"
set libraryDependencies += "com.github.melrief" %% "pureconfig" % "latest.integration"
set libraryDependencies += "org.tpolecat" %% "doobie-core-cats" % "latest.integration"
set libraryDependencies += "com.typesafe.scala-logging" %% "scala-logging" % "latest.integration"
set libraryDependencies += "com.typesafe.akka" %% "akka-http" % "latest.integration"
set libraryDependencies += "org.flywaydb" % "flyway-core" % "latest.integration"
set libraryDependencies += "org.postgresql" % "postgresql" % "latest.integration"
set libraryDependencies += "com.chuusai" %% "shapeless" % "latest.integration"
set libraryDependencies += "org.specs2" %% "specs2-core" % "latest.integration"
set libraryDependencies += "org.specs2" %% "specs2-scalacheck" % "latest.integration"
set libraryDependencies += "org.scalacheck" %% "scalacheck" % "latest.integration"
set libraryDependencies += "com.github.alexarchambault" %% "scalacheck-shapeless_1.13" % "latest.integration"
set libraryDependencies += "org.typelevel" %% "scalaz-specs2" % "latest.integration"
set libraryDependencies += "com.pauldijou" %% "jwt-core" % "latest.integration"
set libraryDependencies += "com.amazonaws" % "aws-java-sdk" % "1.11.181"
set resolvers += "keyczar" at "https://raw.githubusercontent.com/google/keyczar/master/java/maven/"
set libraryDependencies += "org.keyczar" % "keyczar" % "0.71h"
session save
compile
exit
EOF

sbt about