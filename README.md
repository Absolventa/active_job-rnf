# ActiveJob::RNF [![Build Status](https://travis-ci.org/Absolventa/active_job-rnf.svg?branch=master)](https://travis-ci.org/Absolventa/active_job-rnf)

Based on the assumption that a queued job has lost its raison d'être when
its argument had been deleted, **ActiveJob::RNF** ignores deserialization errors
originating from a failed attempt to load that resource.

## Usage

Add this to your Gemfile:

```
gem 'active_job-rnf'
```

It will automatically infect ActiveJob::Base.

## Changelog

See [releases](https://github.com/Absolventa/active_job-rnf/releases).
