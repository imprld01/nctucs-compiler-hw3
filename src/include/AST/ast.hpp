#ifndef __AST_H
#define __AST_H

#include <cstdint>
#include <string>
#include <vector>

#include "utils/location.hpp"
#include "visitor/AstNodeVisitor.hpp"

class AstNode {
   private:
    std::vector<AstNode*> children;

   public:
    AstNode(const uint32_t line, const uint32_t col);
    virtual ~AstNode() = 0;

    Location getLocation() const;
    void visitChildNodes(AstNodeVisitor& dumper) const;
    void append(AstNode* child);
    const std::vector<AstNode*>& getChildren() const;
    virtual void visitedBy(AstNodeVisitor& dumper) const = 0;

   protected:
    Location location;
};

#endif
